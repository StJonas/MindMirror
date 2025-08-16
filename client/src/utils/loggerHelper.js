export async function postLog({ 
  event = "page_visit", 
  userId, 
  page, 
  data = {} 
} = {}) {
  const LOGGER_URL = import.meta.env.VITE_LOGGER_URL;
  try {
    await fetch(`${LOGGER_URL}log`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        event: event,
        userId: userId,
        page: page,
        data: data || {}
      })
    });
  } catch (error) {
    console.warn("Logger server not available:", error);
  }
}
//start with node logger.js