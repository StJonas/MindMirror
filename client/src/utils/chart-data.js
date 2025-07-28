import { fetchWithAuth } from './apiHelpers';

export async function getTopicEntryChartData(userId) {
  const API_URL = "http://localhost:3000";
  // Define your topics and their endpoints
  const topics = [
    { name: "Habits", endpoint: `/users/${userId}/habit_histories` },
    { name: "Journal", endpoint: `/users/${userId}/journal_entries` },
    { name: "Gratitude", endpoint: `/users/${userId}/gratitude_entries` },
    { name: "Emotions", endpoint: `/users/${userId}/emotion_log_entries` },
    { name: "Recharge", endpoint: `/users/${userId}/recharge_logs` },
    { name: "Freetext", endpoint: `/users/${userId}/freetext_entries` },
  ];

  // Fetch all topic entries in parallel
  const results = await Promise.all(
    topics.map(topic =>
      fetchWithAuth(`${API_URL}${topic.endpoint}`)
        .then(res => res)
        .catch(() => [])
    )
  );

  // Count entries per topic
  const labels = topics.map(t => t.name);
  const datasetData = results.map(entries => Array.isArray(entries) ? entries.length : 0);

  return {
    type: "bar",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Frequency",
          data: datasetData,
          backgroundColor: ["#d1fffc", "#daffc1", "#ffe1c1", "#c1d8ff", "#ffc1e1", "#e1ffc1"],
          borderWidth: 3,
        },
      ],
    },
    options: {
      responsive: true,
      lineTension: 1,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            padding: 25,
          },
        },
      },
    },
  };
}

export async function getWordCount(userId) {
  const API_URL = "http://localhost:3000";
  const topics = [
    { name: "Journal", endpoint: `/users/${userId}/journal_entries` },
    { name: "Gratitude", endpoint: `/users/${userId}/gratitude_entries` },
    { name: "Emotions", endpoint: `/users/${userId}/emotion_log_entries` },
    { name: "Freetext", endpoint: `/users/${userId}/freetext_entries` },
  ];

  // Fetch all topic entries in parallel
  const results = await Promise.all(
    topics.map(topic =>
      fetchWithAuth(`${API_URL}${topic.endpoint}`)
        .then(entries => entries)
        .catch(() => [])
    )
  );

  // Count words per topic
  const wordCounts = {};
  topics.forEach((topic, idx) => {
    const entries = results[idx];
    // Assume each entry has a 'content' field with the logged text
    const count = Array.isArray(entries)
      ? entries.reduce((sum, entry) => {
          if (entry.content && typeof entry.content === "string") {
            return sum + entry.content.trim().split(/\s+/).length;
          }
          return sum;
        }, 0)
      : 0;
    wordCounts[topic.name] = count;
  });

  return wordCounts;
}