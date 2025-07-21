<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Journal History</h2>
    </div>
    <div class="section-box">
      <div class="header-row">
        <h3 class="section-title">Number of entries: {{ sumEntries }}</h3>
      </div>
    </div>
    <div v-for="entry in entries" :key="entry.id" class="general-input">
      <h3 class="section-title">{{ entry.entry_date }}</h3>
      <h2>{{ entry.prompt_title }}</h2>
      <p>
        <em>{{ entry.content }}</em>
      </p>
    </div>
  </div>
</template>

<script setup>
import { inject, computed } from "vue";

const entries = inject("entries");
const emit = defineEmits(["navigateBackToJournal"]);

const sumEntries = computed(() => Array.isArray(entries) ? entries.length : (entries?.value?.length || 0));
</script>

<style scoped>

</style>
