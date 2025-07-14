<template>
  <div class="page-styling">
    <div class="header-row">
      <h2 v-if="userId">{{ currentDate }}</h2>
      <router-link
        v-if="userId"
        to="/GratitudeLog"
        style="pointer-events: auto"
      >
        <button type="button" class="log-button">
          <img
            src="/log.svg"
            alt="Log"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
    </div>
    <div class="section-box" v-if="userId">
      <h2 class="section-title">Daily Gratitude Question</h2>
      <div v-if="prompts && prompts.length === 0">
      <div class="general-input">
        <h2>No prompts yet</h2>
      <input
        v-model="newPromptTitle"
        placeholder="Create your first gratitude prompt"
        class="general-input"
      />
      <button @click="addPrompt" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
      </div>
      </div>
      <!-- When prompts exist -->
      <div v-else>
        <GratitudeInput
          v-for="prompt in prompts"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, ref } from "vue";
import GratitudeInput from "./GratitudeInput.vue";

const API_URL = inject("API_URL");
const userId = inject("userId");
const prompts = inject("gratitude_prompts", ref([]));
const newPromptTitle = ref("");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});


const addPrompt = async () => {
  if (!newPromptTitle.value.trim()) {
    alert("Prompt title cannot be empty.");
    return;
  }
  const res = await fetch(`${API_URL}/gratitude_prompts`, {
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
  });

  if (res.ok) {
    alert("Prompt added!");
    window.location.reload();
  } else {
    const errorData = await res.json();
    alert("Error", errorData);
  }
};

</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
