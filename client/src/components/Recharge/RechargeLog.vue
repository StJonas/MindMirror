<template>
  <div class="topic-log">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row-log">
      <router-link to="/RechargeOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Recharge History</h2>
    </div>
    <LoadingBar :visible="isLoading" />
    <div v-for="(dayEntries, date) in groupedEntries" :key="date">
      <h2>Complete on {{ date }}</h2>
      <div v-for="entry in dayEntries" :key="entry.id" 
        class="general-input"
        >
      <h3 class="section-title">{{ entry.exercise }}</h3>
      <p class="user-note"><em>{{ entry.note }}</em></p>
    </div>
    </div>
  </div>
</template>

<script setup>
import { inject, ref, onMounted, computed } from "vue";
import LoadingBar from "../LoadingBar.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchSortedEntries } from '../../utils/apiHelpers';

const entries = ref([]);
const userId = inject("userId");
const API_URL = inject("API_URL");
const isLoading = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const fetchRechargeEntries = async () => {
  try {
    const data = await fetchSortedEntries(`${API_URL}/users/${userId.value}/recharge_logs`);
    if (!data) {
      showToast("Error loading log entries!", "error");
      entries.value = [];
      return;
    }
    entries.value = Array.isArray(data) ? data : [];
  } catch (error) {
    showToast("Error loading log entries!", "error");
    entries.value = [];
  }
};

const groupedEntries = computed(() => {
  const groups = {};
  (entries.value || []).forEach(entry => {
    const date = entry.created_at.split("T")[0];
    if (!groups[date]) groups[date] = [];
    groups[date].push(entry);
  });
  return groups;
});

onMounted(async () => {
  isLoading.value = true;
  await fetchRechargeEntries();
  isLoading.value = false;
});
</script>

<style scoped>
.section-title {
  background-color: green;
  color: white;
  border-radius: 4px;
  text-align: center;
}
.user-note {
  font-style: italic;
  color: #ccc;
  padding: 12px;
  border-left: 4px solid #28a745;
  background: #1f1f1f;
  border-radius: 6px;
  margin-top: 10px;
}
</style>
