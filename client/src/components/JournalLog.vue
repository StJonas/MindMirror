<template>
  <div class="journal-log">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Journal Log</h2>
    </div>

    <!-- <div v-for="entry in journalEntries" :key="entry.id" class="journal-entry">
        <h2>{{ entry.title }}</h2>
        <p>{{ entry.content }}</p>
        <p><em>{{ entry.date }}</em></p>
      </div> -->
    <div class="journal-entry">
      <h3>Entry 1</h3>
      <p>contents</p>
      <p><em>01.12.2024</em></p>
    </div>
    <div class="journal-entry">
      <h3>Entry 2</h3>
      <p>contents</p>
      <p><em>12.12.2024</em></p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";

const journalEntries = ref([]);
const userId = inject("userId");
const API_URL = "http://localhost:3000";
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "short",
  year: "numeric",
});
const emit = defineEmits(["navigateBackToJournal"]);

const fetchJournalEntries = async () => {
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    journalEntries.value = await res.json();
  }
};

onMounted(() => {
  fetchJournalEntries();
});

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

.journal-log button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
