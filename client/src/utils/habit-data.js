export async function getHabitChartData() {
  const userId = localStorage.getItem("userId");
  const API_URL = "http://localhost:3000/";

  const [historiesResponse, habitsResponse] = await Promise.all([
    fetch(`${API_URL}/users/${userId}/habit_histories`),
    fetch(`${API_URL}/habits?user_id=${userId}`),
  ]);

  const historiesData = await historiesResponse.json();
  const habitsData = await habitsResponse.json();

  //console.log("user: ", userId);
  //console.log("historiesData: ", historiesData);
  //console.log("habitsData", habitsData);

  // mapping of habit IDs to names
  const habitNames = habitsData.reduce((names, habit) => {
    names[habit.id] = habit.name;
    return names;
  }, {});

  const habitCounts = historiesData.reduce((counts, history) => {
    counts[history.habit_id] = (counts[history.habit_id] || 0) + 1;
    return counts;
  }, {});

  const labels = Object.keys(habitCounts).map((id) => habitNames[id]);
  const datasetData = Object.values(habitCounts);

  return {
    type: "bar",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Frequency",
          data: datasetData,
          backgroundColor: ["#d1fffc", "#daffc1"],
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
