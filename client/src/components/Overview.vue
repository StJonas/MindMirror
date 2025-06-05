<template>
  <div class="page-styling">
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
import HabitsOverview from "./Habits/HabitsOverview.vue";
import JournalOverview from "./Journal/JournalOverview.vue";
import JournalLog from "./Journal/JournalLog.vue";
import AddPrompt from "./Journal/AddPrompt.vue";
import AddHabit from "./Habits/AddHabit.vue";
import Statistics from "./Habits/HabitStatistics.vue";
import EditHabit from "./Habits/EditHabit.vue";
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
