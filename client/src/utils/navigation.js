import { ref } from "vue";

const currentPage = ref("habits");
const selectedHabitId = ref(null);

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

export {
  currentPage,
  selectedHabitId,
  navigateToJournalLog,
  navigateToAddPrompt,
  navigateToStatistics,
  navigateToAddHabit,
  navigateToEditHabit,
  navigateBackToJournal,
  navigateBackToHabit,
};
