<template>
  <div class="prompt-input">
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
      @click="saveJournalEntry(prompt.content)"
      class="edit-button"
    >
      <img
        src="/public/save.svg"
        alt="Save"
        class="icon"
        style="width: 24px; height: 24px"
      />
    </button>
  </div>
</template>

<script setup>
import { defineProps, inject } from "vue";

const props = defineProps({
  prompt: Object,
});
const API_URL = "http://localhost:3000";

const userId = inject("userId");
const entries = inject("entries");

const saveJournalEntry = async (content) => {
  const today = new Date();
  const entryDate = today.toISOString().split("T")[0];

  // Find existing entry for the prompt
  let existingEntry = null;
  if (props.prompt.weekly) {
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday

    existingEntry = entries.value.find(
      (entry) =>
        entry.prompt_id === props.prompt.id &&
        new Date(entry.entry_date) >= startOfWeek &&
        new Date(entry.entry_date) <= endOfWeek
    );
  } else {
    existingEntry = entries.value.find(
      (entry) =>
        entry.prompt_id === props.prompt.id && entry.entry_date === entryDate
    );
  }

  // If an existing entry is found, update it; otherwise, create a new entry
  if (existingEntry) {
    const updateRes = await fetch(
      `${API_URL}/journal_entries/${existingEntry.id}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          content: content,
        }),
      }
    );

    if (updateRes.ok) {
      console.log("Journal entry updated successfully");
    } else {
      const errorData = await updateRes.json();
      console.error("Error updating journal entry:", errorData);
    }
  } else {
    const createRes = await fetch(`${API_URL}/journal_entries`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        content: content,
        entry_date: entryDate,
        user_id: userId.value,
        prompt_id: props.prompt.id,
        prompt_title: props.prompt.title,
      }),
    });

    if (createRes.ok) {
      console.log("Journal entry saved successfully");
    } else {
      const errorData = await createRes.json();
      console.error("Error saving journal entry:", errorData);
    }
  }
};
</script>

<style scoped>
.prompt-input {
  margin-bottom: 20px;
}

.styled-input {
  width: 300px;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}

.icon {
  width: 24px;
  height: 24px;
}
</style>
