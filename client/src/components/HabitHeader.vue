<template>
  <div class="habit-header" v-if="userId">
    <h2>{{ calendarHeading }}</h2>
    <router-link to="/AddHabit">
      <button type="button">Add Habit</button>
    </router-link>
    <router-link to="/stats">
      <button type="button">Statistics</button>
    </router-link>
  </div>
</template>
<script setup>
import { ref, watch, inject } from "vue";

const userId = inject("userId");
const calendarHeading = ref("");

const updateCalendarHeading = () => {
  const today = new Date();
  const firstDayOfWeek = new Date(
    today.getFullYear(),
    today.getMonth(),
    today.getDate() - today.getDay() + 1
  );
  const lastDayOfWeek = new Date(
    today.getFullYear(),
    today.getMonth(),
    today.getDate() - today.getDay() + 7
  );

  const formatDate = (date) =>
    `${date.getDate()}.${date.getMonth() + 1}.${date.getFullYear()}`;

  calendarHeading.value = `Calender week ${getCalendarWeek(
    firstDayOfWeek
  )} - ${formatDate(firstDayOfWeek)} - ${formatDate(lastDayOfWeek)}`;
};

const getCalendarWeek = (date) => {
  const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
  const millisecondsPerDay = 24 * 60 * 60 * 1000;
  return Math.ceil(
    ((date - firstDayOfYear) / millisecondsPerDay +
      firstDayOfYear.getDay() +
      1) /
      7
  );
};

watch(
  userId,
  (newUserId) => {
    if (newUserId) {
      updateCalendarHeading();
    }
  },
  { immediate: true }
);
</script>
<style>
.habit-header {
  display: flex;
  align-items: center;
  gap: 30px;
}

.habit-header button {
  flex-shrink: 0;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
