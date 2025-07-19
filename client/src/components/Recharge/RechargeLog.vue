<template>
  <div class="topic-log">
    <div class="header-row-log">
      <router-link to="/RechargeOverview">
        <button type="button">&lt;</button>
      </router-link>

      <h2>Recharge Log</h2>
    </div>

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

const entries = ref([]);
const userId = inject("userId");
const API_URL = inject("API_URL");

const fetchRechargeEntries = async () => {
  const res = await fetch(`${API_URL}/users/${userId.value}/recharge_logs`);
  const data = await res.json();
  entries.value = Array.isArray(data) ? data : [];
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

onMounted(() => {
  fetchRechargeEntries();
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
