const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const cors = require('cors');
const app = express();
app.use(cors({ origin: 'http://localhost:5173' }));
const PORT = 4000;

app.use(bodyParser.json());

app.post('/log', (req, res) => {
  const now = new Date();
  const timestamp = now.toISOString().split('.')[0];
  const logEntry = {
    timestamp: timestamp,
    ...req.body
  };
  fs.appendFile('logs.txt', JSON.stringify(logEntry) + '\n', err => {
    if (err) {
      console.error('Failed to write log:', err);
      return res.status(500).send('Failed to log');
    }
    console.log('Log entry added:', logEntry.timestamp);
    res.status(200).send('Logged');
  });
});

app.listen(PORT, () => {
  console.log(`Logger running on http://localhost:${PORT}`);
});