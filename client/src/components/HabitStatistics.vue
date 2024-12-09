<template>
  <div class="form-container">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Add Statistics</h2>
    </div>
    <canvas id="habit-chart" width="800" height="400"></canvas>
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
<style scoped>
.header-row {
  display: flex;
  align-items: center;
  gap: 20px;
}
.form-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-left: 20px;
}
.form-container button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
