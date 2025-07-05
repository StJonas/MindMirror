<template>
  <div class="page-styling">
    <div class="header-row">
      <h2 v-if="userId">{{ currentDate }}</h2>
      <router-link
        v-if="userId"
        to="/GratitudeLog"
        :class="{ 'disabled-button': isEditMode }"
        :tabindex="isEditMode ? -1 : 0"
        aria-disabled="isEditMode"
        style="pointer-events: auto"
      >
        <button type="button" class="log-button" :disabled="isEditMode">
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
      <template v-if="!isEditMode">
        <GratitudeInput
          v-for="prompt in prompts"
          :key="prompt.id"
          :prompt="prompt"
          class="general-input"
        />
      </template>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect, ref } from "vue";
import GratitudeInput from "./GratitudeInput.vue";

const userId = inject("userId");
const prompts = inject("gratitude_prompts");
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
