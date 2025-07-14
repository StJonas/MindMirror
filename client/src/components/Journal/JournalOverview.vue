<template>
  <div class="page-styling">
    <div class="header-row">
      <h2 v-if="userId">{{ currentDate }}</h2>
      <router-link
        v-if="userId"
        to="/addPrompt"
        :class="{ 'disabled-button': isEditMode }"
        :tabindex="isEditMode ? -1 : 0"
        aria-disabled="isEditMode"
        style="pointer-events: auto"
      >
        <button type="button" :disabled="isEditMode">
          <img
            src="/add.svg"
            alt="Add"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <router-link
        v-if="userId"
        to="/journalLog"
        :class="{ 'disabled-button': isEditMode }"
        :tabindex="isEditMode ? -1 : 0"
        aria-disabled="isEditMode"
        style="pointer-events: auto"
      >
        <button type="button" :disabled="isEditMode">
          <img
            src="/log.svg"
            alt="Log"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <button
        v-if="userId"
        type="button"
        @click="toggleEditMode"
        :class="['edit-button', { 'enabled-button': isEditMode }]"
      >
        <img
          src="/edit.svg"
          alt="Edit"
          class="icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
    <div class="section-box" v-if="userId">
      <h2 class="section-title">Weekly Journaling Questions</h2>

      <template v-if="!isEditMode">
        <JournalInput
          v-for="prompt in prompts.filter((p) => p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </template>

      <template v-else>
        <EditPrompt
          v-for="prompt in prompts.filter((p) => p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </template>
    </div>
    <div class="section-box" v-if="userId">
      <h2 class="section-title">Daily Journaling Questions</h2>

      <template v-if="!isEditMode">
        <JournalInput
          v-for="prompt in prompts.filter((p) => !p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </template>

      <template v-else>
        <EditPrompt
          v-for="prompt in prompts.filter((p) => !p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </template>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect, ref, onMounted } from "vue";
import JournalInput from "./JournalInput.vue";
import EditPrompt from "./EditPrompt.vue";

const userId = inject("userId");
const API_URL = inject("API_URL");
const prompts = ref([]);
const entries = inject("entries");
const isEditMode = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const matchEntriesWithPrompts = () => {
  const today = new Date();
  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
  const endOfWeek = new Date(startOfWeek);
  endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday

  prompts.value.forEach((prompt) => {
    const entry = entries.value.find((entry) => {
      const entryDate = new Date(entry.entry_date);
      if (prompt.id === entry.prompt_id) {
        if (prompt.weekly) {
          return entryDate >= startOfWeek && entryDate <= endOfWeek;
        } else {
          return entryDate.toDateString() === today.toDateString();
        }
      }
      return false;
    });

    if (entry) {
      prompt.content = entry.content;
    }
  });
};

const toggleEditMode = () => {
  isEditMode.value = !isEditMode.value;
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

onMounted(() => {
  if (userId.value) {
    fetchPrompts();
  }
});

watchEffect(async () => {
  if (entries.value) {
    matchEntriesWithPrompts();
  }
});
</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
