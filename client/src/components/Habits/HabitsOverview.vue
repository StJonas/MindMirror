<template>
  <div class="page-styling">
    <Toast ref="toast" message="Habit saved successfully!" />
    <!-- Calendar Week and Dates Heading -->
    <HabitHeader
      :currentDay="currentDay"
      :isCurrentWeek="isCurrentWeek"
      @nextWeek="changeWeek('next')"
      @prevWeek="changeWeek('prev')"
      @navigateToStatistics="emitNavigateToStatistics"
      @navigateToAddHabit="navigateToAddHabit"
    />

    <!-- List of Habits -->
    <div v-for="habit in habits" :key="habit.id" class="habit-container">
      <div v-if="!habit.is_timed">
        <h2 class="habit-name">{{ habit.name }}</h2>
        <button
          type="button"
          class="button"
          @click="emitNavigateToEditHabit(habit.id)"
        >
          <img
            src="/public/edit.svg"
            alt="Edit"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
        <div class="checkboxes">
          <Checkboxes
            v-if="habits.length && !habit.is_timed"
            :habitId="habit.id"
            :currentDay="currentDay"
            :isCurrentWeek="isCurrentWeek"
            @save-success="handleSaveSuccess(habit.id)"
            @save-failure="handleSaveFailure(habit.id)"
          />
        </div>
      </div>
    </div>
  </div>

  <div v-for="habit in habits" :key="habit.id" class="habit-container">
    <div v-if="habit.is_timed">
      <div style="margin-left: 30px; margin-bottom: 40px; margin-top: 30px">
        <h2>Timed Habits:</h2>
      </div>
      <h2 style="margin-left: 40px; transform: translateY(15px)">
        {{ habit.name }}
      </h2>
      <button
        type="button"
        class="button"
        @click="emitNavigateToEditHabit(habit.id)"
      >
        <img src="/public/edit.svg" alt="Edit" class="icon" />
      </button>
      <div class="habit-container">
        <HabitDurationTracker
          :habitId="habit.id"
          :initialDuration="habit.duration"
          class="habit-duration-tracker"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import Checkboxes from "./Checkboxes.vue";
import HabitDurationTracker from "./HabitDurationTracker.vue";
import HabitHeader from "./HabitHeader.vue";
import Toast from "../Toast.vue";

import { inject, ref, watchEffect, onMounted, computed } from "vue";

const habits = ref([]);
const API_URL = inject("API_URL");
const userId = inject("userId");
const emit = defineEmits([
  "navigateToStatistics",
  "navigateToAddHabit",
  "navigateToEditHabit",
]);
//const currentDay = ref(new Date(2025, 12, 9)); //for testing
const currentDay = ref(new Date());
const toastRef = ref(null);

const handleSaveSuccess = (habitId) => {
  console.log(`Save successful for habit ${habitId}`);
  console.log("toast value", toastRef.value);
  if (toastRef.value && typeof toastRef.value.show === "function") {
    toastRef.value.show();
  } else {
    console.error("Toast component's show method is not defined.");
  }
};

const handleSaveFailure = (error) => {
  console.error(`Save failed: ${error}`);
};

const changeWeek = (direction) => {
  if (direction === "next") {
    currentDay.value = new Date(currentDay.value);
    currentDay.value.setDate(currentDay.value.getDate() + 7);
  } else if (direction === "prev") {
    currentDay.value = new Date(currentDay.value);
    currentDay.value.setDate(currentDay.value.getDate() - 7);
  }
};

const isCurrentWeek = computed(() => {
  const today = new Date();
  const startOfWeek = new Date(
    today.getFullYear(),
    today.getMonth(),
    today.getDate() - today.getDay() + (today.getDay() === 0 ? -6 : 1)
  );

  const endOfWeek = new Date(
    startOfWeek.getFullYear(),
    startOfWeek.getMonth(),
    startOfWeek.getDate() + 6
  );
  //console.log(currentDay.value >= startOfWeek && currentDay.value <= endOfWeek);
  return currentDay.value >= startOfWeek && currentDay.value <= endOfWeek;
});

const fetchHabitsForWeek = async (currentDay) => {
  if (userId.value) {
    const url = `${API_URL}/users/${
      userId.value
    }/habits?week_start=${currentDay.toISOString()}`;
    //console.log("Generated URL:", url);
    const res = await fetch(
      url
      //`http://localhost:3000/users/4/habits?week_start="2024-11-10T19:41:41.123Z"`
      //http://localhost:3000/users/4/habits?week_start=2024-11-30T10:44:02.133Z
    );
    habits.value = await res.json();
  }
};

onMounted(async () => {
  fetchHabitsForWeek(new Date());
});

const emitNavigateToStatistics = () => {
  emit("navigateToStatistics");
};

const navigateToAddHabit = () => {
  emit("navigateToAddHabit");
};

const emitNavigateToEditHabit = (habitId) => {
  emit("navigateToEditHabit", habitId);
};

watchEffect(async () => {
  if (userId.value) {
    await fetchHabitsForWeek(currentDay.value);
  }
});
</script>

<style scoped>
.page-styling {
  margin-left: 40px;
}

.page-styling button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}

.habit-container {
  position: relative;
}

.habit-container button {
  margin-left: 200px;
  position: absolute;
}
.checkboxes {
  margin-left: 320px;
  margin-top: 0px;
  position: relative;
}
.habit-container h2 {
  margin-bottom: -25px;
}

.habit-name {
  transform: translateY(15px);
}
.habit-duration-tracker {
  margin-left: 280px;
  position: absolute;
}
</style>
