<template>
  <div class="journal-log">
    <div class="header-row">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Journal Log</h2>
    </div>
    <div class="section-box">
      <div v-for="entry in entries" :key="entry.id" class="general-input">
        <h3 class="section-title">{{ entry.entry_date }}</h3>
        <h2>{{ entry.prompt_title }}</h2>
        <p>
          <em>{{ entry.content }}</em>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject } from "vue";

const entries = inject("entries");
const emit = defineEmits(["navigateBackToJournal"]);
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
