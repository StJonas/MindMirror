<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/GratitudeOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Gratitude History</h2>
    </div>
    <div class="section-box">
      <div class="header-row">
        <h3 class="section-title">Number of entries: {{ sumEntries }}</h3>
      </div>
    </div>
    <LoadingBar :visible="isLoading" />
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
import { inject, ref, onMounted, computed } from "vue";
import LoadingBar from "../LoadingBar.vue";

const isLoading = ref(false);
const entries = inject("gratitude_entries");

const sumEntries = computed(() =>
  Array.isArray(entries?.value) ? entries.value.length : 0
);

onMounted(() => {
  isLoading.value = true;
  if (entries.value) {
    isLoading.value = false;
  }
});
</script>

<style scoped></style>
