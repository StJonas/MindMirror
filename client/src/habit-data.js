export async function getHabitChartData() {
  const [historiesResponse, habitsResponse] = await Promise.all([
    fetch("http://localhost:3000/habit_histories"),
    fetch("http://localhost:3000/habits"),
  ]);

  const historiesData = await historiesResponse.json();
  const habitsData = await habitsResponse.json();

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
          backgroundColor: ["#ffd1dc", "#d1fffc", "#daffc1"],
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
