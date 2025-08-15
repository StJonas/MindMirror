<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Journal History</h2>
    </div>
    <h3 class="section-title">Number of entries: {{ sumEntries }}</h3>
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
import { inject, computed, onMounted } from "vue";
import { postLog } from '../../utils/loggerHelper';

const entries = inject("entries");
const userId = inject("userId");

onMounted(() => {
  postLog({ userId: userId.value, page: "JournalLog" });
});

const sumEntries = computed(() => Array.isArray(entries) ? entries.length : (entries?.value?.length || 0));
</script>

<style scoped></style>
