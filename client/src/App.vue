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

import { ref, onMounted, provide } from "vue";
import { fetchWithAuth, fetchSortedEntries } from './utils/apiHelpers';

const entries = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const gratitude_entries = ref([]);
const gratitude_prompts = ref([]);
const emotions = ref([]);

provide("userId", userId);
provide("username", username);
provide("entries", entries);
provide("API_URL", API_URL);
provide("gratitude_prompts", gratitude_prompts);
provide("gratitude_entries", gratitude_entries);
provide("emotions", emotions);

const fetchUserData = async () => {
  try {
    const response = await fetchWithAuth(`${API_URL}/users/${userId.value}`);

    if (response) {
      const data = await response;
      userId.value = data.id;
      username.value = data.username;
      fetchEntries();
      fetchGratitudeEntries();
      fetchEmotions();
      fetchGratitudePrompts();
    } else {
      console.error("Failed to fetch user data");
    }
  } catch (error) {
    console.error("Error fetching user data:", error);
  }
};

const fetchGratitudePrompts = async () => {
  if (userId.value) {
    const res = await fetchWithAuth(`${API_URL}/users/${userId.value}/gratitude_prompts`);
    gratitude_prompts.value = await res;
    gratitude_prompts.value.forEach((gratitude_prompt) => {
      gratitude_prompt.content = "";
    });
  }
};

const fetchEntries = async () => {
  if (userId.value) {
    const res = await fetchSortedEntries(`${API_URL}/users/${userId.value}/journal_entries`, "entry_date");
    entries.value = await res;
  }
};

const fetchGratitudeEntries = async () => {
  if (userId.value) {
    const res = await fetchSortedEntries(`${API_URL}/users/${userId.value}/gratitude_entries`, "entry_date");
    gratitude_entries.value = await res;
  }
};

const fetchEmotions = async () => {
  const data = await fetchWithAuth(`${API_URL}/emotions`);
  emotions.value = Array.isArray(data) ? data : [];
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
