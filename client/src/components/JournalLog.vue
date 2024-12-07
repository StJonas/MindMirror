<template>
  <div class="journal-log">
    <h1>Journal Log</h1>
    <!-- <div v-for="entry in journalEntries" :key="entry.id" class="journal-entry">
        <h2>{{ entry.title }}</h2>
        <p>{{ entry.content }}</p>
        <p><em>{{ entry.date }}</em></p>
      </div> -->
    <div class="journal-entry">
      <h2>Entry</h2>
      <p>contents</p>
      <p><em>date</em></p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";

const journalEntries = ref([]);
const userId = inject("userId");
const API_URL = "http://localhost:3000";

const fetchJournalEntries = async () => {
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    journalEntries.value = await res.json();
  }
};

onMounted(() => {
  fetchJournalEntries();
});
</script>

<style scoped>
.journal-log {
  padding: 20px;
}

.journal-entry {
  margin-bottom: 20px;
}
</style>
