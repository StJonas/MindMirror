<template>
  <div>
    <div class="header">
      <h1>{{ greeting }}</h1>
      <button type="button" v-if="userId">
        <router-link to="/AddHabit">Add Habit</router-link>
      </button>
      <router-link to="/login" v-if="!userId">
        <button>Login</button>
      </router-link>
      <router-link to="/signup" v-if="!userId">
        <button>Signup</button>
      </router-link>
      <router-link to="/stats" v-if="userId">
        <button>Statistics</button>
      </router-link>
      <button @click="logout" v-if="userId">Logout</button>
    </div>

    <!-- Calendar Week and Dates Heading -->
    <div class="header" v-if="userId">
      <h2>{{ calendarHeading }}</h2>
    </div>

    <!-- List of Habits -->
    <div v-for="habit in habits" :key="habit.id" class="header">
      <h2>{{ habit.name }}</h2>
      <button type="button" v-if="habits.length">
        <router-link :to="`/edit/${habit.id}`">Edit</router-link>
      </button>
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
      />
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

  const currentHour = new Date().getHours();
  if (currentHour < 12) {
    greeting.value = "Good Morning " + username.value;
  } else if (currentHour < 18) {
    greeting.value = "Good Afternoon " + username.value;
  } else {
    greeting.value = "Good Evening " + username.value;
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
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
}
</style>
