<template>
  <div class="page-styling">
    <div class="header">
      <h2>{{ currentDate }}</h2>
      <button
        v-if="userId"
        type="button"
        @click="navigateToAddPrompt"
        :class="{ 'disabled-button': isEditMode }"
        :disabled="isEditMode"
      >
        Add Prompt
      </button>
      <button
        v-if="userId"
        type="button"
        @click="navigateToJournalLog"
        :class="{ 'disabled-button': isEditMode }"
        :disabled="isEditMode"
      >
        Journal Log
      </button>
      <button
        v-if="userId"
        type="button"
        @click="toggleEditMode"
        :class="['edit-button', { 'enabled-button': isEditMode }]"
      >
        <img
          src="/public/edit.svg"
          alt="Edit"
          class="icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
    <div class="header">
      <h2>Weekly Prompts</h2>
    </div>
    <div v-if="!isEditMode">
      <div v-for="prompt in prompts" :key="prompt.id" class="">
        <div v-if="prompt.weekly">
          <JournalInput :key="prompt.id" :prompt="prompt" />
        </div>
      </div>
    </div>
    <div v-if="isEditMode">
      <div v-for="prompt in prompts" :key="prompt.id" class="">
        <div v-if="prompt.weekly">
          <EditPrompt :prompt="prompt" />
        </div>
      </div>
    </div>
    <div class="header">
      <h2>Daily Prompts</h2>
    </div>
    <div v-if="!isEditMode">
      <div v-for="prompt in prompts" :key="prompt.id" class="">
        <div v-if="!prompt.weekly">
          <JournalInput :key="prompt.id" :prompt="prompt" />
        </div>
      </div>
    </div>
    <div v-if="isEditMode">
      <div v-for="prompt in prompts" :key="prompt.id" class="">
        <div v-if="!prompt.weekly">
          <EditPrompt :prompt="prompt" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect, ref } from "vue";
import JournalInput from "./JournalInput.vue";
import EditPrompt from "./EditPrompt.vue";

const userId = inject("userId");
const prompts = inject("prompts");
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

const navigateToJournalLog = () => {
  emit("navigateToJournalLog");
};

const navigateToAddPrompt = () => {
  emit("navigateToAddPrompt");
};

const toggleEditMode = () => {
  isEditMode.value = !isEditMode.value;
};

watchEffect(async () => {
  if (entries.value) {
    matchEntriesWithPrompts();
  }
});
</script>

<style scoped>
.page-styling {
  margin-left: 0;
}
.header {
  display: flex;
  align-items: center;
  gap: 30px;
  margin-left: -90px;
}

.header button {
  margin-left: 200px;
  position: relative;
}

.styled-input {
  width: 500px;
  height: 80px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  color: #333;
  margin-left: 20px;
}

.page-styling button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}

.edit-button {
  width: 60px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.disabled-button {
  background-color: #a9a9a9;
  cursor: not-allowed;
}

.enabled-button {
  background-color: orange;
}
</style>
