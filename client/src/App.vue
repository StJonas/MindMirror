<template>
  <div class="">
    <OverviewHeader @logout="logout" />
    <!-- <OverviewNavigationButtons v-if="!hideNavigation" /> -->

    <div class="content">
      <router-view />
    </div>
  </div>
</template>

<script setup>
import OverviewHeader from "./components/OverviewHeader.vue";
import OverviewNavigationButtons from "./components/OverviewNavigationButtons.vue";

import { ref, onMounted, provide, computed } from "vue";
import { useRoute } from "vue-router";

const habits = ref([]);
const prompts = ref([]);
const predefinedPrompts = ref([]);
const entries = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const gratitude_prompts = ref([]);
const predefinedGratitudePrompts = ref([]);
const gratitude_entries = ref([]);

provide("userId", userId);
provide("username", username);
provide("habits", habits);
provide("prompts", prompts);
provide("entries", entries);
provide("predefinedPrompts", predefinedPrompts);
provide("API_URL", API_URL);
provide("gratitude_prompts", gratitude_prompts);
provide("predefinedGratitudePrompts", predefinedGratitudePrompts);
provide("gratitude_entries", gratitude_entries);

const route = useRoute();

const fetchUserData = async () => {
  try {
    const response = await fetch(`${API_URL}/users/${userId.value}`);
    if (response.ok) {
      const data = await response.json();
      userId.value = data.id;
      username.value = data.username;
      sessionToken.value = localStorage.getItem("sessionToken");
      fetchHabits();
      fetchPrompts();
      fetchEntries();
      fetchPredefinedPrompts();
      fetchGratitudeEntries();
      fetchGratitudePrompts();
      fetchPredefinedGratitudePrompts();
    } else {
      console.error("Failed to fetch user data");
    }
  } catch (error) {
    console.error("Error fetching user data:", error);
  }
};

const fetchHabits = async () => {
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }
};

const fetchPrompts = async () => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/prompts`;
    const res = await fetch(url);
    prompts.value = await res.json();
    prompts.value.forEach((prompt) => {
      prompt.content = "";
    });
  }
};

const fetchEntries = async () => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/journal_entries`;
    const res = await fetch(url);
    entries.value = await res.json();
  }
};

const fetchPredefinedPrompts = async () => {
  const res = await fetch(`${API_URL}/prompts?predefined=true`);
  predefinedPrompts.value = await res.json();
};

const fetchGratitudePrompts = async () => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/gratitude_prompts`;
    const res = await fetch(url);
    gratitude_prompts.value = await res.json();
    gratitude_prompts.value.forEach((gratitude_prompt) => {
      gratitude_prompt.content = "";
    });
  }
};

const fetchGratitudeEntries = async () => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/gratitude_entries`;
    const res = await fetch(url);
    gratitude_entries.value = await res.json();
  }
};

const fetchPredefinedGratitudePrompts = async () => {
  const res = await fetch(`${API_URL}/gratitude_prompts?predefined=true`);
  predefinedGratitudePrompts.value = await res.json();
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

onMounted(() => {
  userId.value = localStorage.getItem("userId");
  fetchUserData();
  fetchHabits();
});
</script>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
