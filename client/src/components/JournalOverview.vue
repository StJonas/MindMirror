<template>
  <div class="page-styling">
    <div class="header">
      <h2>{{ currentDate }}</h2>
      <button v-if="userId" type="button" @click="navigateToAddPrompt">
        Add Prompt
      </button>
      <button v-if="userId" type="button" @click="navigateToJournalLog">
        Journal Log
      </button>
      <button
        v-if="userId"
        type="button"
        @click="navigateToEditPrompts"
        class="edit-button"
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

    <!-- List of Prompts -->
    <div v-for="prompt in prompts" :key="prompt.id" class="">
      <div v-if="prompt.weekly">
        <h2>{{ prompt.title }}</h2>
        <input
          type="text"
          v-model="prompt.content"
          placeholder="content"
          min="1"
          class="styled-input"
        />
        <button
          v-if="userId"
          type="button"
          @click="saveJournalEntry(prompt.id, prompt.content)"
          class="edit-button"
        >
          <img
            src="/public/save.svg"
            alt="Edit"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </div>
    </div>
    <div class="header">
      <h2>Daily Prompts</h2>
    </div>
    <div v-for="prompt in prompts" :key="prompt.id" class="">
      <div v-if="!prompt.weekly">
        <h2>{{ prompt.title }}</h2>
        <input
          type="text"
          v-model="prompt.content"
          placeholder="content"
          min="1"
          class="styled-input"
        />
        <button
          v-if="userId"
          type="button"
          @click="saveJournalEntry(prompt.id, prompt.content, prompt.title)"
          class="edit-button"
        >
          <img
            src="/public/save.svg"
            alt="Edit"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect } from "vue";

const API_URL = "http://localhost:3000/";
const userId = inject("userId");
const prompts = inject("prompts");
const entries = inject("entries");
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const saveJournalEntry = async (promptId, content, title) => {
  console.log("content ", content);
  const res = await fetch(`${API_URL}/journal_entries`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      content: content,
      entry_date: new Date().toISOString().split("T")[0],
      user_id: userId.value,
      prompt_id: promptId,
      prompt_title: title,
    }),
  });

  if (res.ok) {
    console.log("Journal entry saved successfully");
  } else {
    const errorData = await res.json();
    console.error("Error saving journal entry:", errorData);
  }
};

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
</style>
