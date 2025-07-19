<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/EmotionsOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Emotion Log</h2>
    </div>

    <div v-for="(dayEntries, date) in groupedEntries" :key="date">
      <h2>{{ date }}</h2>
      <div v-for="entry in dayEntries" :key="entry.id" 
        class="general-input"
        :style="{ backgroundColor: getEmotionColor(entry.emotion_id) }">
      <h3>{{ getEmotionName(entry.emotion_id) }}</h3>
      <p><em>{{ entry.note }}</em></p>
    </div>
    </div>
  </div>
</template>

<script setup>
import { inject, computed, ref, onMounted } from "vue";

const entries = ref([]);
const userId = inject("userId");
const emotions = inject("emotions");
const API_URL = inject("API_URL");

const fetchEmotionEntries = async () => {
  const res = await fetch(`${API_URL}/users/${userId.value}/emotion_log_entries`);
  const data = await res.json();
  entries.value = Array.isArray(data) ? data : [];
};

function getEmotionName(id) {
  const emotion = emotions.value ? emotions.value.find(e => e.id === id) : null;
  return emotion ? emotion.name : "";
}

// Group entries by date
const groupedEntries = computed(() => {
  const groups = {};
  (entries.value || []).forEach(entry => {
    const date = entry.created_at.split("T")[0];
    if (!groups[date]) groups[date] = [];
    groups[date].push(entry);
  });
  return groups;
});

function getEmotionColor(id) {
  const emotion = emotions.value ? emotions.value.find(e => e.id === id) : null;
  return emotion ? emotion.color : "#fff";
}

onMounted(() => {
  fetchEmotionEntries();
});
</script>

<style scoped>

</style>
