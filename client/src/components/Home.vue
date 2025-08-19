<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <h2 v-if="!userId">Please sign up or login</h2>
      <div v-if="userId" class="header-row-flex">
        <span class="header-username" :title="username">Hello {{ username }}</span>
        <span class="header-date">{{ currentDate }}</span>
      </div>
    </div>

    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use the Home Page</h3>
        <ul>
          <li>
            <b>Return to the homepage from any page </b> by clicking the
            <img src="/circle.svg" alt="Logo" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>MindMIrror</b> button on the top left.
          </li>
          <li>
            <b>Edit your visible topics</b> by clicking the
            <img src="/edit.svg" alt="Edit" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Edit</b> button on the top right.
          </li>
          <li>
            <b>Show or hide topics</b> by clicking the
            <img src="/eye1.svg" alt="Show" class="icon" style="width: 20px; vertical-align: middle;" />
            or
            <img src="/eye2.svg" alt="Hide" class="icon" style="width: 20px; vertical-align: middle;" />
            icons while in edit mode.
          </li>
          <li>
            <b>Go to a topic</b> by clicking its card.
          </li>
          <li>
            <b>View your statistics</b> by clicking the
            <img src="/chart.svg" alt="Statistics" class="icon" style="width: 20px; vertical-align: middle;" />
            button on the top left.
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>

    <div class="home-container" v-if="userId">
      <button class="edit-btn-top" @click="toggleEditMode">
        <img v-if="!isEditMode" src="/edit.svg" alt="Edit" class="icon" style="width: 24px; height: 24px" />
        <img v-else src="/save.svg" alt="Save" class="icon" style="width: 24px; height: 24px" />
      </button>
      <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      <router-link v-if="userId" to="/Statistics" style="pointer-events: auto" class="chart-btn-top">
        <button type="button" :disabled="isEditMode">
          <img src="/chart.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
        </button>
      </router-link>
      <template v-for="topic in topics" :key="topic.name">
        <button v-if="isEditMode" class="home-btn" type="button" @click="toggleTopic(topic.name)">
          <img :src="topic.icon" alt="icon" class="home-icon" />
          {{ topic.name }}
          <img :src="selectedTopics.includes(topic.name) ? '/eye1.svg' : '/eye2.svg'" alt="eye" class="eye-icon"
            style="margin-top: 8px;" />
        </button>
        <router-link v-else-if="selectedTopics.includes(topic.name)" :to="topic.route" class="home-btn">
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
import { postLog } from "../utils/loggerHelper.js";

const toastRef = ref(null);
const showTutorial = ref(false);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const API_URL = inject("API_URL");
const userId = inject("userId");
const username = inject("username");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});
const initialTopics = ref([]);
const isEditMode = ref(false);

async function toggleEditMode() {
  isEditMode.value = !isEditMode.value;
  if (!isEditMode.value) {
    if (JSON.stringify(selectedTopics.value) === JSON.stringify(initialTopics.value)) {
      showToast("No changes made to topics.", "info");
      return;
    }
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
      initialTopics.value = [...selectedTopics.value];

      postLog({
        event: "topic_preferences_updated",
        userId: userId.value,
        page: "Homepage",
        data: { topics: selectedTopics.value },
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
  if (userId.value) {
    try {
      const res = await fetchWithAuth(`${API_URL}/users/${userId.value}/user_topic_preferences`);
      if (res && Array.isArray(res.topics) && res.topics.length > 0) {
        selectedTopics.value = res.topics;
        initialTopics.value = [...res.topics];
      } else {
        selectedTopics.value = topics.map(t => t.name);
        initialTopics.value = topics.map(t => t.name);
      }
    } catch (error) {
      console.error("Failed to load topic preferences:", error);
      showToast("Failed to load topic preferences!", "error");
      // Fallback: enable all topics
      selectedTopics.value = topics.map(t => t.name);
    }
  }
});
</script>

<style scoped>
.home-container {
  display: grid;
  position: relative;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
  justify-items: center;
  align-items: center;
  padding: 24px 0;
  padding-top: 64px;
  width: 420px;
  margin: 0 auto;
  background: #95b3db;
  border-radius: 18px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
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

.chart-btn-top {
  position: absolute;
  top: 8px;
  left: 12px;
  margin: 0;
  z-index: 10;
}

.edit-btn-top {
  position: absolute;
  top: 8px;
  right: 12px;
  z-index: 10;
}

.help-btn {
  position: absolute;
  top: 8px;
  left: 50%;
  transform: translateX(-50%);
  margin: 0;
  z-index: 10;
}

.header-row-flex {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 24px;
  justify-content: center;
  flex-wrap: wrap;
}

.header-username {
  font-size: 1.5rem;
  font-weight: 600;
  max-width: 240px;
  overflow: hidden;
  white-space: nowrap;
  display: inline-block;
}

.header-date {
  font-size: 1.1rem;
  color: #333;
  font-weight: 400;
}

@media (max-width: 600px) {
  .home-container {
    width: 80vw;
    max-width: 400px;
    padding: 12px 0;
    padding-top: 56px;
    gap: 12px;
    grid-template-columns: 1fr 1fr;
    margin-top: 20px;
  }

  .home-btn {
    font-size: 1.2rem;
    padding: 24px 0;
    width: 96%;
    height: 140px;
    max-height: 140px;
    padding: 0;
  }

  .header-row-title {
    font-size: 1rem;
    max-width: 80vw;
    text-align: center;
  }

  .header-username {
    max-width: 180px;
  }
}
</style>
