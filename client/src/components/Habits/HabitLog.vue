<template>
  <div class="topic-log">
    <div class="header-row" v-if="userId">
      <router-link to="/HabitOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Habit Log</h2>
    </div>
    <div class="section-box">
      <div class="header-row">
        <h3 class="section-title">Total habits checked: {{ sumHabits }}</h3>
      </div>
    </div>
  </div>
  <div v-for="day in habits" :key="day.date" class="section-box" style="">
    <div class="header-row">
      <h3 class="section-title">{{ day.date }}</h3>
    </div>
    <div
      v-for="habit in day.habits"
      :key="habit.name"
      class="general-input"
      style="display: flex; align-items: center; gap: 12px"
    >
      <span>{{ habit.name }}</span>
    </div>
  </div>
</template>

<script setup>
import { inject, ref, watchEffect, onMounted, computed } from "vue";

const habits = ref([]);
const API_URL = inject("API_URL");
const userId = inject("userId");

const fetchHabitLog = async (currentDay) => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/habit_log`;
    const res = await fetch(url);
    habits.value = await res.json();
  }
};

onMounted(async () => {
  fetchHabitLog(new Date());
});

const sumHabits = computed(() =>
  habits.value.reduce(
    (sum, day) => sum + day.habits.filter((habit) => habit.completed).length,
    0
  )
);
</script>

<style scoped>
.general-input {
  background-color: green;
  color: white;
}
</style>
