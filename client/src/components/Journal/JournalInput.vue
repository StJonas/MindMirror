<template>
  <div class="section-box">
    <h2>{{ prompt.title }}</h2>
    <input
      type="text"
      v-model="prompt.content"
      placeholder="Your answer"
      min="1"
      class="general-input"
    />
    <div class="button-wrapper">
      <button
        v-if="userId"
        type="button"
        @click="saveJournalEntry(prompt.content)"
        class="save-button"
      >
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { inject } from "vue";

const props = defineProps({
  prompt: Object,
});
const API_URL = inject("API_URL");

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
      window.location.reload();
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
      window.location.reload();
    } else {
      const errorData = await createRes.json();
      console.error("Error saving journal entry:", errorData);
    }
  }
};
</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
