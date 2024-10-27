<template>
  <div class="page-styling">
    <div class="header">
      <h1>{{ greeting }}</h1>

      <router-link to="/login" v-if="!userId">
        <button type="button">Login</button>
      </router-link>
      <router-link to="/signup" v-if="!userId">
        <button type="button">Signup</button>
      </router-link>
      <div class="logout">
        <button @click="logout" v-if="userId">Logout</button>
      </div>
    </div>

    <div class="navigation-buttons">
      <button
        type="button"
        @click="currentPage = 'habits'"
        :class="{ active: currentPage === 'habits' }"
      >
        Habits
      </button>
      <button
        type="button"
        @click="currentPage = 'journaling'"
        :class="{ active: currentPage === 'journaling' }"
      >
        Journal
      </button>
      <button>+</button>
    </div>

    <div class="content">
      <div v-if="currentPage === 'habits'">
        <HabitsOverview />
      </div>
      <div v-else-if="currentPage === 'journaling'">
        <JournalingOverview />
      </div>
    </div>
  </div>
</template>

<script setup>
import HabitsOverview from "./HabitsOverview.vue";
import JournalingOverview from "./JournalingOverview.vue";
import { ref, onMounted, inject } from "vue"; //habit

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const greeting = ref("");
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const currentPage = ref("habits");

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
.page-styling {
  margin-left: 140px;
  min-width: 100vh;
}
.header button router-link {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
.logout button {
  margin-left: 1500px;
  position: absolute;
  border-color: black;
  top: 80px;
}
.navigation-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.navigation-buttons button {
  background-color: lightblue;
  color: white;
  border: none;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  cursor: pointer;
  border-radius: 4px;
}
.navigation-buttons button.active {
  background-color: #45a049;
}
.content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.content > div {
  flex: 1;
}
</style>
