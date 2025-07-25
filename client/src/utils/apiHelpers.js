export async function fetchWithAuth(url, options = {}, raw = false) {
  const token = localStorage.getItem("jwt");

  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
    ...(options.headers || {})
  };

  const response = await fetch(url, {
    ...options,
    headers
  });

  if (raw) return response;
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(data?.errors || 'API Error');
  }

  return data;
}

export function sortByNewest(entries, dateKey = "date") {
  return [...entries].sort((a, b) => new Date(b[dateKey]) - new Date(a[dateKey]));
}

export async function fetchSortedEntries(url, dateKey = "date") {
  try {
    const data = await fetchWithAuth(url);  
    return sortByNewest(Array.isArray(data) ? data : [], dateKey);
  } catch (error) {
    return null;
  }
}