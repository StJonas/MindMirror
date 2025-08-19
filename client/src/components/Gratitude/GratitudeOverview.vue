<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/heart.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Gratitude</h2>
        <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      </div>
      <router-link v-if="userId" to="/GratitudeLog" style="pointer-events: auto">
        <button type="button">
          <img src="/log.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
        </button>
      </router-link>
    </div>

    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use Gratitude</h3>
        <ul>
          <li>On this page you can do daily gratitude journaling. You can create your own gratitude question or select a
            predefined one.</li>
          <li>You can create your own question by typing it in the input field and clicking
            <img src="/save.svg" alt="Save" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Save</b>.
          </li>
          <li>View your gratitude journal history by clicking
            <img src="/log.svg" alt="Log" class="icon" style="width: 20px; vertical-align: middle;" />.
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>

    <transition-group name="card-move" tag="div">
      <div class="section-box" v-if="userId && showPrompts">
        <h2 class="section-title">Daily Gratitude Question</h2>
        <div v-if="prompts && prompts.length === 0" :key="'no-prompts'" class="general-input">
          <h2>No question yet</h2>
          <span class="text-label">select new predefined question:</span>
          <select v-model="selectedPromptId" class="general-input">
            <option v-for="prompt in predefinedGratitudePrompts" :key="prompt.id" :value="prompt.id">
              {{ prompt.title }}
            </option>
          </select>
          <span class="text-label">create own question:</span>
          <input v-model="newPromptTitle" placeholder="Create gratitude question" class="general-input" />
          <button @click="addPrompt" class="save-button">
            <img src="/save.svg" alt="Save" class="white-icon" />
          </button>
        </div>

        <GratitudeInput v-for="prompt in prompts" :key="prompt.id" :prompt="prompt" class="general-input" />

      </div>
    </transition-group>

  </div>
</template>

<script setup>
import { inject, ref, onMounted, watch } from "vue";
import GratitudeInput from "./GratitudeInput.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';
import { postLog } from '../../utils/loggerHelper';

const API_URL = inject("API_URL");
const userId = inject("userId");
const prompts = inject("gratitude_prompts", ref([]));
const predefinedGratitudePrompts = inject("predefined_gratitude_prompts");
const newPromptTitle = ref("");
const showPrompts = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const selectedPromptId = ref(null);
const showTutorial = ref(false);

const addPrompt = async () => {
  if (!newPromptTitle.value.trim()) {
    showToast("Please select an emotion", "info");
    return;
  }
  const res = await fetchWithAuth(`${API_URL}/gratitude_prompts`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      title: newPromptTitle.value,
      user_id: userId.value,
      weekly: false,
      predefined: false,
    }),
  },
    true
  );

  if (res.ok) {
    showToast("Question added", "success");
    postLog({ event: "gratitude_prompt_added", userId: userId.value, page: "GratitudeOverview", data: { promptTitle: newPromptTitle.value } });

    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Error saving question!", "error");
  }
};

onMounted(() => {
  setTimeout(() => {
    showPrompts.value = true;
  }, 400);
  postLog({ userId: userId.value, page: "GratitudeOverview" });
});

watch(selectedPromptId, (id) => {
  const selected = predefinedGratitudePrompts.value.find(p => p.id === id);
  if (selected) {
    newPromptTitle.value = selected.title;
  }
});
</script>

<style scoped>
@media (max-width: 600px) {}
</style>
