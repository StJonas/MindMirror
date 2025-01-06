<template>
  <div class="journal-log">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Journal Log</h2>
    </div>

    <div v-for="entry in entries" :key="entry.id" class="journal-entry">
      <h2>{{ entry.prompt_title }}</h2>
      <p>{{ entry.content }}</p>
      <p>
        <em>{{ entry.entry_date }}</em>
      </p>
    </div>
  </div>
</template>

<script setup>
import { inject } from "vue";

const prompts = inject("prompts");
const entries = inject("entries");
const emit = defineEmits(["navigateBackToJournal"]);

const getPromptTitle = (promptId) => {
  const prompt = prompts.value.find((prompt) => prompt.id === promptId);
  return prompt ? prompt.title : "Unknown Prompt";
};

const goBack = () => {
  emit("navigateBackToJournal");
};
</script>

<style scoped>
.header-row {
  display: flex;
  align-items: center;
  gap: 20px;
}

.journal-log {
  margin-left: 20px;
}

.journal-entry {
  margin-bottom: 20px;
}
</style>
