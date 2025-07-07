<template>
  <div class="page-styling">
    <div class="header-row">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Add Question</h2>
    </div>
    <div class="general-input">
      <div class="toggle-container">
        <span class="text-label">Daily Question</span>
        <!-- Textual label -->
        <div class="switch" @mousedown.prevent="">
          <input
            type="checkbox"
            id="isWeekly"
            v-model="is_weekly"
            @change="updatePredefinedPrompts"
            class="checkbox"
          />

          <label for="isWeekly" class="label"></label>
        </div>
        <span class="text-label">Weekly Question</span>
      </div>
      <select
        v-model="selectedPrompt"
        @change="updatePrompt"
        class="general-input"
      >
        <option value="" disabled>Select predefined question</option>
        <option
          v-for="prompt in filteredPredefinedPrompts"
          :key="prompt.id"
          :value="prompt.title"
        >
          {{ prompt.title }}
        </option>
      </select>
      <input
        type="text"
        v-model="prompt"
        placeholder="write your own question"
        class="general-input"
      />

      <button @click="createPrompt" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject, computed } from "vue";

const is_weekly = ref(false);
const userId = inject("userId");
const prompt = ref("");
const selectedPrompt = ref("");
const emit = defineEmits(["navigateBackToJournal"]);
const API_URL = inject("API_URL");
const predefinedPrompts = inject("predefinedPrompts");
import router from "../../router";

const filteredPredefinedPrompts = computed(() => {
  return predefinedPrompts.value.filter(
    (prompt) => prompt.weekly === is_weekly.value
  );
});

const updatePrompt = () => {
  prompt.value = selectedPrompt.value;
};

const createPrompt = async () => {
  const res = await fetch(`${API_URL}/prompts`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      title: prompt.value,
      user_id: userId.value,
      weekly: is_weekly.value,
      predefined: false,
    }),
  });

  if (res.ok) {
    prompt.value = "";
    router.push("/JournalOverview").then(() => {
      window.location.reload();
    });
  } else {
    const errorData = await res.json();
    console.error("Error creating prompt:", errorData);
  }
};
</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
