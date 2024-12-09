<template>
  <div>
    <h1>Statistics</h1>
    <canvas id="habit-chart" width="800" height="400"></canvas>
    <router-link to="/">
      <button>Go Back</button>
    </router-link>
  </div>
</template>

<script>
import {
  Chart,
  LinearScale,
  BarController,
  CategoryScale,
  BarElement,
} from "chart.js";

Chart.register(LinearScale, BarController, CategoryScale, BarElement);

import { getHabitChartData } from "../habit-data.js";

export default {
  name: "HabitChart",
  data() {
    return {
      habitChartData: null,
    };
  },
  async mounted() {
    const ctx = document.getElementById("habit-chart");
    this.habitChartData = await getHabitChartData();
    new Chart(ctx, this.habitChartData);
  },
};
</script>
