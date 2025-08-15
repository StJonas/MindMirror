export async function postLog({ 
  event = "page_visit", 
  userId, 
  page, 
  data = {} 
} = {}) {
    fetch('http://localhost:4000/log', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        event: event,
        userId: userId,
        page: page,
        data: data || {}
      })
    });
}
//start with node logger.js