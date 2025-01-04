<template>
  <div class="habit-header" v-if="userId">
    <button @click="changeWeek('prev')">&lt;</button>
    <h2>{{ calendarHeading }}</h2>
    <button v-if="!props.isCurrentWeek" @click="changeWeek('next')">
      &gt;
    </button>

    <button v-if="userId" type="button" @click="navigateToAddHabit">
      Add Habit
    </button>
    <button v-if="userId" type="button" @click="navigateToStatistics">
      Statistics
    </button>

    <!-- <router-link to="/stats">
      <button type="button">Statistics</button>
    </router-link> -->
  </div>
</template>
<script setup>
import { ref, inject, computed } from "vue";

const userId = inject("userId");
const emit = defineEmits([
  "nextWeek",
  "prevWeek",
  "navigateToStatistics",
  "navigateToAddHabit",
]);

const props = defineProps({
  currentDay: Date,
  isCurrentWeek: Boolean,
});

const calendarHeading = computed(() => {
  const firstDayOfWeek = new Date(props.currentDay);
  firstDayOfWeek.setDate(
    firstDayOfWeek.getDate() - firstDayOfWeek.getDay() + 1
  );

  const lastDayOfWeek = new Date(
    firstDayOfWeek.getFullYear(),
    firstDayOfWeek.getMonth(),
    firstDayOfWeek.getDate() + 6
  );

  const formatDate = (date) =>
    `${date.getDate()}.${date.getMonth() + 1}.${date.getFullYear()}`;

  return `Week of ${formatDate(firstDayOfWeek)} - ${formatDate(lastDayOfWeek)}`;
});

const navigateToStatistics = () => {
  emit("navigateToStatistics");
};

const navigateToAddHabit = () => {
  emit("navigateToAddHabit");
};

const changeWeek = (direction) => {
  emit(direction === "next" ? "nextWeek" : "prevWeek");
};
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
