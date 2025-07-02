<template>
  <div class="journal-log">
    <div class="header-row">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Journal Log</h2>
    </div>

    <div v-for="entry in entries" :key="entry.id" class="general-input">
      <h2>{{ entry.entry_date }}</h2>
      <h3>{{ entry.prompt_title }}</h3>
      <p>
        <em>{{ entry.content }}</em>
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
.journal-log {
  margin-left: 20px;
}

@media (max-width: 600px) {
  .journal-log {
    margin-left: 0px;
    margin-top: 30px;
    font-size: 0.8rem;
  }
}
</style>
