<template>
  <div class="form-container">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Add Statistics</h2>
    </div>
    <canvas id="habit-chart" width="800" height="400"></canvas>
  </div>
</template>

<script setup>
import {
  Chart,
  LinearScale,
  BarController,
  CategoryScale,
  BarElement,
} from "chart.js";
import { ref, onMounted } from "vue";
import { getHabitChartData } from "../../utils/habit-data.js";

Chart.register(LinearScale, BarController, CategoryScale, BarElement);

const emit = defineEmits(["navigateBackToHabit"]);
const habitChartData = ref(null);

const goBack = () => {
  emit("navigateBackToHabit");
};

onMounted(async () => {
  const ctx = document.getElementById("habit-chart");
  habitChartData.value = await getHabitChartData();
  new Chart(ctx, habitChartData.value);
});
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
