<template>
  <div class="page-styling">
    <!-- Calendar Week and Dates Heading -->
    <HabitHeader />

    <!-- List of Habits -->
    <div v-for="habit in habits" :key="habit.id" class="habit-container">
      <h2>{{ habit.name }}</h2>
      <router-link :to="`/edit/${habit.id}`">
        <button type="button">Edit</button>
      </router-link>
      <div class="checkboxes">
        <Checkboxes
          v-if="habits.length && !habit.is_timed"
          :habitId="habit.id"
          :userId="userId"
          @save-success="handleSaveSuccess"
          @save-failure="handleSaveFailure"
        />

        <HabitDurationTracker
          v-else
          :habitId="habit.id"
          :initialDuration="habit.duration"
          @save-duration="handleSaveDuration"
          class="habit-duration-tracker"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import Checkboxes from "../components/Checkboxes.vue";
import HabitDurationTracker from "./HabitDurationTracker.vue";
import HabitHeader from "./HabitHeader.vue";

import { inject } from "vue";

const habits = inject("habits");
const userId = inject("userId");

const handleSaveSuccess = (habitId) => {
  console.log(`Save successful for habit ${habitId}`);
};

const handleSaveFailure = (error) => {
  console.error(`Save failed: ${error}`);
};
</script>

<style scoped>
.page-styling {
  margin-left: 40px;
}

.logout {
  margin-left: 1500px;
  margin-bottom: 500px;
  position: absolute;
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
  margin-top: 10px;
  position: relative;
}
.habit-container h2 {
  margin-bottom: -35px;
  position: relative;
}
.habit-duration-tracker {
  bottom: 10px;
}
</style>
