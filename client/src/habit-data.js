export const habitChartData = {
  type: "bar",
  data: {
    labels: ["Habit 1", "Habit 2", "Habit 3"],
    datasets: [
      {
        label: "Frequency",
        data: [10, 20, 15],
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

export default habitChartData;
