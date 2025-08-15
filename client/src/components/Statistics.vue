<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/chart.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Statistics</h2>
      </div>
      <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      <button v-if="userId" @click="toggleEditMode" class="edit-btn-top">
        <img v-if="!isEditMode" src="/edit.svg" alt="Edit" class="icon" style="width: 24px; height: 24px" />
        <img v-else src="/save.svg" alt="Save" class="icon" style="width: 24px; height: 24px" />
      </button>
    </div>
    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use Statistics</h3>
        <ul>
          <li>
            View your overall progress and activity across all topics.
          </li>
          <li>
            Use the <img src="/edit.svg" alt="Edit" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Edit</b> button to customize which statistics are visible.
          </li>
          <li>
            Click the <img src="/eye1.svg" alt="Show" class="icon" style="width: 20px; vertical-align: middle;" /> or
            <img src="/eye2.svg" alt="Hide" class="icon" style="width: 20px; vertical-align: middle;" /> icons to show
            or hide individual stats.
          </li>
          <li>
            Save your preferences with the <img src="/save.svg" alt="Save" class="icon"
              style="width: 20px; vertical-align: middle;" /> button.
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>
    <div v-if="!isLoaded" class="loading-spinner">
      <LoadingBar :visible="!isLoaded" />
    </div>

    <div v-else>
      <!-- Top Cards -->
      <div class="stats-cards">
        <div v-if="visibleStats.totalEntries || isEditMode" class="stat-card">
          <h3>Total Entries all topics</h3>
          <p>{{ totalEntries }}</p>
          <button v-if="isEditMode" class="eye-btn" @click="toggleStat('totalEntries')">
            <img :src="visibleStats.totalEntries ? '/eye1.svg' : '/eye2.svg'" alt="eye" />
          </button>
        </div>
        <div v-if="visibleStats.totalWords || isEditMode" class="stat-card">
          <h3>Total Words Logged</h3>
          <p>{{ totalWords }}</p>
          <button v-if="isEditMode" class="eye-btn" @click="toggleStat('totalWords')">
            <img :src="visibleStats.totalWords ? '/eye1.svg' : '/eye2.svg'" alt="eye" />
          </button>
        </div>
        <div v-if="visibleStats.mostActiveTopic || isEditMode" class="stat-card">
          <h3>Most Active Topic</h3>
          <p>{{ mostActiveTopic }}</p>
          <button v-if="isEditMode" class="eye-btn" @click="toggleStat('mostActiveTopic')">
            <img :src="visibleStats.mostActiveTopic ? '/eye1.svg' : '/eye2.svg'" alt="eye" />
          </button>
        </div>
      </div>

      <!-- Bar Chart -->
      <div class="bar-chart-section" v-if="visibleStats.barChart || isEditMode">
        <div class="side-by-side">
          <h3>Entries per Topic</h3>
          <button v-if="isEditMode" class="eye-btn" @click="toggleStat('barChart')">
            <img :src="visibleStats.barChart ? '/eye1.svg' : '/eye2.svg'" alt="eye" />
          </button>
        </div>

        <canvas id="chart" width="800" height="400"></canvas>
      </div>

      <!-- Table -->
      <div class="stats-table-section" v-if="visibleStats.statsTable || isEditMode">
        <div class="side-by-side">
          <h3>
            Entries & Words per Topic
          </h3>
          <button v-if="isEditMode" class="eye-btn" @click="toggleStat('statsTable')">
            <img :src="visibleStats.statsTable ? '/eye1.svg' : '/eye2.svg'" alt="eye" />
          </button>
        </div>

        <table class="stats-table">
          <thead>
            <tr>
              <th>Topic</th>
              <th>Entries</th>
              <th>Words</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="topic in topics" :key="topic.name">
              <td>{{ topic.name }}</td>
              <td>{{ topicStats[topic.name]?.entries || 0 }}</td>
              <td>{{ topicStats[topic.name]?.words || 0 }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, inject, onMounted, nextTick } from "vue";
import LoadingBar from "./LoadingBar.vue";
import Toast from "./Toast.vue";
import { fetchWithAuth } from '../utils/apiHelpers';
import { useToast } from "../utils/useToast.js";
import { postLog } from "../utils/loggerHelper.js";
import { getTopicEntryChartData, getWordCount } from "../utils/chart-data.js";
import {
  Chart,
  LinearScale,
  BarController,
  CategoryScale,
  BarElement,
} from "chart.js";
Chart.register(LinearScale, BarController, CategoryScale, BarElement);

const API_URL = inject("API_URL");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const userId = inject("userId");
const isEditMode = ref(false);
const chartData = ref(null);
const isLoaded = ref(false);
const totalWords = ref(0);
const topics = ref([
  { name: "Habits" },
  { name: "Journal" },
  { name: "Gratitude" },
  { name: "Emotions" },
  { name: "Recharge" },
  { name: "Freetext" },
]);
const topicStats = ref({});
const showTutorial = ref(false);

const visibleStats = ref({
  totalEntries: true,
  totalWords: true,
  mostActiveTopic: true,
  barChart: true,
  statsTable: true,
});
const originalVisibleStats = ref();

function toggleStat(stat) {
  visibleStats.value[stat] = !visibleStats.value[stat];
}

async function toggleEditMode() {
  isEditMode.value = !isEditMode.value;
  if (!isEditMode.value) {
    const changed = Object.keys(visibleStats.value).some(
      key => visibleStats.value[key] !== originalVisibleStats.value[key]
    );
    if (!changed) {
      showToast("No changes made", "info");
      return;
    }

    try {
      await fetchWithAuth(`${API_URL}/users/${userId.value}/update_stats_visibility`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          stats_visibility: visibleStats.value,
        }),
      });

      originalVisibleStats.value = { ...visibleStats.value };
      showToast("Preferences saved!", "success");
      postLog({
        event: "stats_updated",
        userId: userId.value,
        page: "Statistics",
        data: visibleStats.value,
      });

      setTimeout(() => {
        window.location.reload();
      }, 500);
    } catch (error) {
      console.error("Failed to save preferences:", error);
      showToast("Failed to save preferences!", "error");
    }
  }
}

const totalEntries = computed(() =>
  Object.values(topicStats.value).reduce((sum, t) => sum + (t.entries || 0), 0)
);

const mostActiveTopic = computed(() => {
  let max = 0;
  let topic = "";
  for (const [name, stats] of Object.entries(topicStats.value)) {
    if ((stats.entries || 0) > max) {
      max = stats.entries;
      topic = name;
    }
  }
  return topic || "—";
});

onMounted(async () => {
  postLog({ userId: userId.value, page: "Statistics" });

  const res = await fetchWithAuth(`${API_URL}/users/${userId.value}`);
  if (res && res.stats_visibility) {
    visibleStats.value = { ...visibleStats.value, ...res.stats_visibility };
    originalVisibleStats.value = { ...visibleStats.value };
  }

  const wordCounts = await getWordCount(userId.value);

  Object.entries(wordCounts).forEach(([topic, count]) => {
    if (!topicStats.value[topic]) topicStats.value[topic] = {};
    topicStats.value[topic].words = count;
  });

  totalWords.value = Object.values(wordCounts).reduce((sum, n) => sum + n, 0);

  chartData.value = await getTopicEntryChartData(userId.value);
  const labels = chartData.value.data.labels;
  const counts = chartData.value.data.datasets[0].data;
  labels.forEach((label, idx) => {
    if (!topicStats.value[label]) topicStats.value[label] = {};
    topicStats.value[label].entries = counts[idx];
  });

  isLoaded.value = true;

  await nextTick();

  if (visibleStats.value.barChart || isEditMode.value) {
    const ctx = document.getElementById("chart");
    if (ctx) {
      new Chart(ctx, chartData.value);
    }
  }
});
</script>

<style scoped>
.statistics-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 24px;
}

.stats-cards {
  display: flex;
  gap: 24px;
  margin-bottom: 32px;
}

.stat-card {
  background: #f5f7fa;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  padding: 24px;
  flex: 1;
  text-align: center;
}

.bar-chart-section {
  margin-bottom: 32px;
}

.stats-table-section {
  margin-bottom: 32px;
}

.stats-table {
  width: 100%;
  border-collapse: collapse;
}

.stats-table th,
.stats-table td {
  border: 1px solid #e0e0e0;
  padding: 8px 12px;
  text-align: center;
}

.stats-table th {
  background: #f5f7fa;
}

.eye-btn {
  background: none;
  border: none;
  cursor: pointer;
  margin-left: 8px;
  vertical-align: middle;
}

.eye-btn img {
  width: 24px;
  height: 24px;
}

@media (max-width: 600px) {
  .statistics-page {
    padding: 8px;
  }

  .stats-cards {
    flex-direction: column;
    gap: 12px;
  }

  .stat-card {
    margin-bottom: 8px;
    padding: 12px;
    font-size: 1rem;
  }

  .bar-chart-section {
    margin-bottom: 16px;
    margin-left: -8px;
    padding: 0;
  }

  .bar-chart-section canvas {
    min-width: 280px;
    width: 80vw;
    max-width: 80vw;
  }

  .stats-table-section {
    margin-bottom: 16px;
    padding: 0;
  }

  .stats-table {
    min-width: 320px;
    font-size: 0.95rem;
  }
}
</style>