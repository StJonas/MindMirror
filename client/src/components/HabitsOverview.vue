<template>
  <div class="page-styling">
    <!-- Calendar Week and Dates Heading -->
    <div class="habit-header" v-if="userId">
      <h2>{{ calendarHeading }}</h2>
      <router-link to="/AddHabit" v-if="userId">
        <button type="button">Add Habit</button>
      </router-link>
      <router-link to="/stats" v-if="userId">
        <button type="button">Statistics</button>
      </router-link>
    </div>

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
import { ref, onMounted, inject } from "vue"; //habit

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const greeting = ref("");
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const calendarHeading = ref("");

onMounted(async () => {
  sessionToken.value = localStorage.getItem("sessionToken");
  userId.value = localStorage.getItem("userId");
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }

  //   console.log("session token", sessionToken.value);
  //   console.log("userId.value", userId.value);

  if (userId.value) {
    const userRes = await fetch(`${API_URL}/users/${userId.value}`);
    const userData = await userRes.json();
    username.value = userData.username;
  } else {
    username.value = "";
  }

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

  // Format the dates
  const formatDate = (date) =>
    `${date.getDate()}.${date.getMonth() + 1}.${date.getFullYear()}`;

  // Generate the calendar heading text
  calendarHeading.value = `Calender week ${getCalendarWeek(
    firstDayOfWeek
  )} - ${formatDate(firstDayOfWeek)} - ${formatDate(lastDayOfWeek)}`;
});

// Function to calculate the calendar week
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

const logout = () => {
  userId.value = "";
  username.value = "";
  sessionToken.value = "";

  // Clear user-related data from localStorage
  localStorage.removeItem("userId");
  localStorage.removeItem("sessionToken");
  location.reload();
};

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
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  width: 200%;
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

.habit-header button router-link {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}

.habit-header {
  display: flex;
  align-items: center;
  gap: 10px;
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
  margin-bottom: 50px;
}
</style>
