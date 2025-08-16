const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors({ origin: 'http://localhost:5173' }));
const PORT = process.env.PORT || 4000;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

app.use(bodyParser.json());

const createTableQuery = `
CREATE TABLE IF NOT EXISTS logs (
  id SERIAL PRIMARY KEY,
  timestamp TIMESTAMP NOT NULL,
  event TEXT,
  userId TEXT,
  page TEXT,
  data JSONB
);
`;
pool.query(createTableQuery).catch(console.error);

app.post('/log', async (req, res) => {
  const now = new Date();
  const { event, userId, page, data } = req.body;
  try {
    await pool.query(
      'INSERT INTO logs (timestamp, event, userId, page, data) VALUES ($1, $2, $3, $4, $5)',
      [now, event, userId, page, data]
    );
    res.status(200).send('Logged');
  } catch (err) {
    console.error('Failed to write log:', err);
    res.status(500).send('Failed to log');
  }
});

app.get('/logs', async (req, res) => {
  const auth = req.headers['authorization'];
  if (auth !== `Bearer ${process.env.LOGGER_SECRET}`) {
    return res.status(403).send('Forbidden');
  }
  try {
    const result = await pool.query('SELECT * FROM logs ORDER BY timestamp DESC LIMIT 100');
    res.json(result.rows);
  } catch (err) {
    res.status(500).send('Failed to retrieve logs');
  }
});

app.listen(PORT, () => {
  console.log(`Logger running on port ${PORT}`);
}).on('error', (error) => {
  console.error('Server startup error:', error);
});