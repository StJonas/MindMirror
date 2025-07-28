<template>
  <div class="topic-log">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row-log">
      <router-link to="/EmotionsOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Emotion History</h2>
    </div>
    <h3 class="section-title">Nr. of entries: {{ sumEntries }}</h3>
    <LoadingBar :visible="isLoading" />
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
import LoadingBar from "../LoadingBar.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchSortedEntries } from '../../utils/apiHelpers';

const entries = ref([]);
const userId = inject("userId");
const emotions = inject("emotions");
const API_URL = inject("API_URL");
const isLoading = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const sumEntries = computed(() => entries.value.length);

const fetchEmotionEntries = async () => {
  try {
    const data = await fetchSortedEntries(`${API_URL}/users/${userId.value}/emotion_log_entries`, "created_at");
    entries.value = Array.isArray(data) ? data : [];
  } catch (error) {
    showToast("Error loading log entries!", "error");
    entries.value = [];
  }
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

onMounted(async () => {
  isLoading.value = true;
  await fetchEmotionEntries();
  isLoading.value = false;
});
</script>

<style scoped>

</style>
