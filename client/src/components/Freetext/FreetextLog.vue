<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/FreetextOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Freetext Log</h2>
    </div>

<div v-for="entry in entries" :key="entry.id" class="general-input">
  <h2>{{ entry.date }}</h2>
  <p class="general-input" :class="{ 'greyed-out': entry.done_offline }">
    <em>
      <span v-if="entry.content && entry.content.trim()">{{ entry.content }}</span>
      <span v-else-if="entry.done_offline">done offline</span>
    </em>
  </p>
</div>
  </div>
</template>

<script setup>
import { inject, ref, onMounted } from "vue";

const entries = ref([]);
const userId = inject("userId");
const API_URL = inject("API_URL");

const fetchFreetextEntries = async () => {
  const res = await fetch(`${API_URL}/users/${userId.value}/freetext_entries`);
  const data = await res.json();
  entries.value = Array.isArray(data) ? data : [];
};

onMounted(() => {
  fetchFreetextEntries();
});
</script>

<style scoped>
</style>
