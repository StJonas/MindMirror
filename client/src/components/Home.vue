<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <h2 v-if="!userId">Please sign up or login</h2>
      <h2 v-if="userId">Hello {{ username }}</h2>
      <h2 v-if="userId">{{ currentDate }}</h2>
    </div>
    <button class="edit-btn" @click="toggleEditMode">
      {{ isEditMode ? 'Done' : 'Edit' }}
    </button>
    <div class="home-container" v-if="userId">
      <template v-for="topic in topics" :key="topic.name">
        <button
          v-if="isEditMode"
          class="home-btn"
          type="button"
          @click="toggleTopic(topic.name)"
        >
          <img :src="topic.icon" alt="icon" class="home-icon" />
          {{ topic.name }}
          <img
            :src="selectedTopics.includes(topic.name) ? '/eye1.svg' : '/eye2.svg'"
            alt="eye"
            class="eye-icon"
            style="margin-top: 8px;"
          />
        </button>
        <router-link
          v-else-if="selectedTopics.includes(topic.name)"
          :to="topic.route"
          class="home-btn"
        >
          <img :src="topic.icon" alt="icon" class="home-icon" />
          {{ topic.name }}
        </router-link>
      </template>
    </div>
  </div>
</template>

<script setup>
import { inject, ref, onMounted } from "vue";
import { fetchWithAuth } from '../utils/apiHelpers';
import { selectedTopics, topics } from '../utils/topics.js';
import Toast from "./Toast.vue";
import { useToast } from "../utils/useToast.js";

const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const API_URL = inject("API_URL");
const userId = inject("userId");
const username = inject("username");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const isEditMode = ref(false);

async function toggleEditMode() {
  isEditMode.value = !isEditMode.value;
  if (!isEditMode.value) {
    try {
      await fetchWithAuth(`${API_URL}/users/${userId.value}/user_topic_preferences`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user_id: userId.value,
          topics: selectedTopics.value,
        }),
      });
      showToast("Preferences saved!", "success");
    } catch (error) {
      console.error("Failed to save topic preferences:", error);
      showToast("Failed to save preferences!", "error");
    }
  }
}

function toggleTopic(name) {
  if (!isEditMode.value) return;
  const idx = selectedTopics.value.indexOf(name);
  if (idx === -1) {
    selectedTopics.value.push(name);
  } else {
    selectedTopics.value.splice(idx, 1);
  }
}

onMounted(async () => {
  try {
    const res = await fetchWithAuth(`${API_URL}/users/${userId.value}/user_topic_preferences`);
    if (res && Array.isArray(res.topics) && res.topics.length > 0) {
      selectedTopics.value = res.topics;
    } else {
      selectedTopics.value = topics.map(t => t.name);
    }
  } catch (error) {
    console.error("Failed to load topic preferences:", error);
    showToast("Failed to load topic preferences!", "error");
    // Fallback: enable all topics
    selectedTopics.value = topics.map(t => t.name);
  }
});
</script>

<style scoped>
.home-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
  justify-items: center;
  align-items: center;
  padding: 24px 0;
  width: 420px;
  margin: 0 auto;
  background: #95b3db;
  border-radius: 18px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.home-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #748CAB;
  color: #000000;
  border: none;
  border-radius: 12px;
  padding: 32px 0;
  width: 90%;
  height: 100px;
  font-size: 1.5rem;
  text-decoration: none;
  text-align: center;
  cursor: pointer;
  transition: background 0.2s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin: 0;
}
.home-btn:hover {
  background: #8aa6ca;
}
.home-icon {
  width: 32px;
  height: 32px;
  margin-bottom: 8px;
}

.eye-icon {
  width: 24px;
  height: 24px;
  display: block;
  margin: 0 auto;
}
@media (max-width: 600px) {
  .home-container {
    width: 80vw;
    max-width: 400px;
    padding: 12px 0;
    gap: 12px;
    grid-template-columns: 1fr 1fr;
    margin-top: 20px;
  }
  .home-btn {
    font-size: 1.2rem;
    padding: 24px 0;
    width: 96%;
  }
}
</style>
