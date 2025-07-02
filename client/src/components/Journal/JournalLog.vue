<template>
  <div class="journal-log">
    <div class="header-row">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Journal Log</h2>
    </div>

    <div v-for="entry in entries" :key="entry.id" class="journal-entry">
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
@media (max-width: 600px) {
  .header-row {
    display: flex;
    align-items: center;
    font-size: 0.9rem;
    gap: 20px;
  }

  .journal-log {
    margin-left: 0px;
    margin-top: 30px;
    font-size: 0.8rem;
  }

  .journal-entry {
    margin-bottom: 20px;
    background-color: rgb(70, 69, 69);
    border-radius: 12px;
    margin-top: 10px;
    padding: 2px;
    padding-left: 20px;
  }
}
</style>
