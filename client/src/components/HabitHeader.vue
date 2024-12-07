<template>
  <div class="habit-header" v-if="userId">
    <button @click="changeWeek('prev')">&lt;</button>
    <h2>{{ calendarHeading }}</h2>
    <button v-if="!isCurrentWeek" @click="changeWeek('next')">&gt;</button>

    <router-link to="/AddHabit">
      <button type="button">Add Habit</button>
    </router-link>
    <router-link to="/stats">
      <button type="button">Statistics</button>
    </router-link>
  </div>
</template>
<script setup>
import { ref, watch, inject, defineProps, computed } from "vue";

const userId = inject("userId");
//const calendarHeading = ref("");
//const currentDay = ref(new Date());

const props = defineProps({
  currentDay: Date,
});

const isCurrentWeek = computed(() => {
  const today = new Date();
  const startOfWeek = new Date(
    today.setDate(today.getDate() - today.getDay() + 1)
  );

  return props.currentDay >= startOfWeek;
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

const emit = defineEmits(["nextWeek", "prevWeek"]);
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
