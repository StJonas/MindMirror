<template>
  <div class="topic-log">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row-log">
      <router-link to="/FreetextOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Freetext History</h2>
    </div>

    <h3 class="section-title">Nr. of entries: {{ sumEntries }}</h3>
    <LoadingBar :visible="isLoading" />
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
import { inject, ref, onMounted, computed } from "vue";
import LoadingBar from "../LoadingBar.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchSortedEntries } from '../../utils/apiHelpers.js';
import { postLog } from '../../utils/loggerHelper';

const entries = ref([]);
const userId = inject("userId");
const API_URL = inject("API_URL");
const isLoading = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const sumEntries = computed(() => entries.value.length);

const fetchFreetextEntries = async () => {
  try {
    const data = await fetchSortedEntries(`${API_URL}/users/${userId.value}/freetext_entries`);

    if (!data) {
      showToast("No entries found!", "info");
      entries.value = [];
      return;
    }

    entries.value = data
  } catch (error) {
    showToast("Error loading log entries!", "error");
    entries.value = [];
  }
};

onMounted(async () => {
  isLoading.value = true;
  await fetchFreetextEntries();
  isLoading.value = false;
  postLog({ userId: userId.value, page: "FreetextLog" });
});
</script>

<style scoped></style>
