<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/GratitudeOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Gratitude Log</h2>
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
import { inject, ref, onMounted } from "vue";
import LoadingBar from "../LoadingBar.vue";

const isLoading = ref(false);
const entries = inject("gratitude_entries");

onMounted(() => {
  isLoading.value = true;
  if (entries === null) {
    isLoading.value = false;
  } else {
    isLoading.value = false;
  }
});
</script>

<style scoped>

</style>
