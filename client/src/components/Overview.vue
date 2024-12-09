<template>
  <div class="page-styling">
    <OverviewHeader @logout="logout" />
    <OverviewNavigationButtons
      :currentPage="currentPage"
      @update:currentPage="currentPage = $event"
    />

    <div class="content">
      <div v-if="currentPage === 'habits'">
        <HabitsOverview
          @navigateToAddHabit="navigateToAddHabit"
          @navigateToStatistics="navigateToStatistics"
          @navigateToEditHabit="navigateToEditHabit"
        />
      </div>
      <div v-else-if="currentPage === 'editHabit'">
        <EditHabit
          :habitId="selectedHabitId"
          @navigateBackToHabit="navigateBackToHabit"
        />
      </div>
      <div v-else-if="currentPage === 'addHabit'">
        <AddHabit @navigateBackToHabit="navigateBackToHabit" />
      </div>
      <div v-else-if="currentPage === 'statistics'">
        <Statistics @navigateBackToHabit="navigateBackToHabit" />
      </div>
      <div v-else-if="currentPage === 'journaling'">
        <JournalOverview
          @navigateToJournalLog="navigateToJournalLog"
          @navigateToAddPrompt="navigateToAddPrompt"
        />
      </div>
      <div v-else-if="currentPage === 'journalLog'">
        <JournalLog @navigateBackToJournal="navigateBackToJournal" />
      </div>
      <div v-else-if="currentPage === 'addPrompt'">
        <AddPrompt @navigateBackToJournal="navigateBackToJournal" />
      </div>
    </div>
  </div>
</template>

<script setup>
import HabitsOverview from "./HabitsOverview.vue";
import JournalOverview from "./JournalOverview.vue";
import JournalLog from "./JournalLog.vue";
import AddPrompt from "./AddPrompt.vue";
import AddHabit from "./AddHabit.vue";
import Statistics from "./HabitStatistics.vue";
import EditHabit from "./EditHabit.vue";
import OverviewHeader from "./OverviewHeader.vue";
import OverviewNavigationButtons from "./OverviewNavigationButtons.vue";
import { ref, onMounted, provide } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const currentPage = ref("habits");
const selectedHabitId = ref(null);

provide("userId", userId);
provide("username", username);
provide("habits", habits);

const fetchUserData = async () => {
  try {
    const response = await fetch(`${API_URL}/users/${userId.value}`);
    if (response.ok) {
      const data = await response.json();
      userId.value = data.id;
      username.value = data.username;
      sessionToken.value = localStorage.getItem("sessionToken");
      fetchHabits();
    } else {
      console.error("Failed to fetch user data");
    }
  } catch (error) {
    console.error("Error fetching user data:", error);
  }
};

const fetchHabits = async () => {
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }
};

const navigateToJournalLog = () => {
  currentPage.value = "journalLog";
};

const navigateToAddPrompt = () => {
  currentPage.value = "addPrompt";
};

const navigateToStatistics = () => {
  currentPage.value = "statistics";
};

const navigateToAddHabit = () => {
  currentPage.value = "addHabit";
};

const navigateToEditHabit = (habitId) => {
  selectedHabitId.value = habitId;
  currentPage.value = "editHabit";
};

const navigateBackToJournal = () => {
  currentPage.value = "journaling";
};

const navigateBackToHabit = () => {
  currentPage.value = "habits";
};

onMounted(() => {
  userId.value = localStorage.getItem("userId");
  fetchUserData();
  fetchHabits();
});

const logout = () => {
  userId.value = "";
  username.value = "";
  sessionToken.value = "";

  // Clear user-related data from localStorage
  localStorage.removeItem("userId");
  localStorage.removeItem("sessionToken");
  location.reload();
};
</script>

<style scoped>
.page-styling {
  margin-left: 140px;
  min-width: 100vh;
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.content > div {
  flex: 1;
}
</style>
