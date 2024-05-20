<template>
  <div>
    <div class="header">
      <h1>{{ greeting }}</h1>
      <button type="button">
        <router-link to="/AddHabit">Add Habit</router-link>
      </button>
      <router-link to="/login" v-if="!userId">
        <button>Login</button>
      </router-link>
      <router-link to="/signup" v-if="!userId">
        <button>Signup</button>
      </router-link>
      <button @click="logout" v-if="userId">Logout</button>
    </div>

    <!-- List of Habits -->
    <div v-for="habit in habits" :key="habit.id" class="header">
      <h2>{{ habit.name }}</h2>
      <button type="button" v-if="habits.length">
        <router-link :to="`/edit/${habit.id}`">Edit</router-link>
      </button>
      <Checkboxes v-if="habits.length" />
    </div>
  </div>
</template>

<script setup>
import Checkboxes from "../components/Checkboxes.vue";
import { ref, onMounted, inject } from "vue"; //habit

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const greeting = ref("");
const userId = ref("");
const username = ref("");
const sessionToken = ref("");

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
});

const logout = () => {
  userId.value = "";
  username.value = "";
  sessionToken.value = "";

  // Clear user-related data from localStorage
  localStorage.removeItem("userId");
  localStorage.removeItem("sessionToken");
  location.reload();
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
