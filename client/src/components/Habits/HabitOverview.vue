<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row" v-if="userId">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/calender.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Habits</h2>
        <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      </div>
      <div class="side-by-side">
        <router-link to="/AddHabit" style="pointer-events: auto">
          <button type="button">
            <img src="/add.svg" alt="Add" class="icon" style="width: 24px; height: 24px" />
          </button>
        </router-link>
        <router-link to="/HabitLog" style="pointer-events: auto">
          <button type="button">
            <img src="/log.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
          </button>
        </router-link>
      </div>

      <div v-if="showTutorial" class="tutorial-modal">
        <div class="tutorial-content">
          <h3>How to use Habits</h3>
          <ul>
            <li>Add a new habit by clicking the
              <img src="/add.svg" alt="Add" class="icon" style="width: 20px; vertical-align: middle;" />
              button.
            </li>
            <li>Mark a habit as completed for today by clicking the
              <img src="/save.svg" alt="Save" class="icon" style="width: 20px; vertical-align: middle;" />
              <b>Save</b> button.
            </li>
            <li>
              You can view your habit log by clicking the
              <img src="/log.svg" alt="Log" class="icon" style="width: 20px; vertical-align: middle;" />
              (book icon).
            </li>
          </ul>
          <button @click="showTutorial = false" class="close-btn">Close</button>
        </div>
      </div>

    </div>
    <LoadingBar :visible="isLoading" />
    <!-- List of Habits -->
    <div v-if="!isLoading && habits.length === 0" :key="'no-habits'" class="general-input"
      style="text-align:center; margin: 2rem 0;">
      <h2>No habits yet</h2>
      <p>Create your first habit by clicking the <img src="/add.svg" alt="Add"
          style="width: 20px; vertical-align: middle;" /> button above.</p>
    </div>
    <transition-group name="card-move" tag="div">
      <div v-for="habit in sortedHabits" :key="habit.id"
        :class="['section-box', { 'checked-border': savedHabits.has(habit.id) }]">
        <div class="content-row">
          <h2 class="section-title">{{ habit.name }}</h2>
          <router-link :to="`/editHabit/${habit.id}`" style="pointer-events: auto">
            <button type="button">
              <img src="/edit.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
            </button>
          </router-link>
        </div>
        <hr class="content-divider" />
        <div class="habit-action-row">
          <span class="habit-description">{{ habit.description }}</span>
          <button type="button" @click="saveHabit(habit.id)" class="save-button">
            <img src="/save.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
          </button>
        </div>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import LoadingBar from "../LoadingBar.vue";
import { inject, ref, onMounted, computed } from "vue";
import { fetchWithAuth } from '../../utils/apiHelpers';

const habits = ref([]);
const API_URL = inject("API_URL");
const userId = inject("userId");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const savedHabits = ref(new Set());
const isLoading = ref(false);
const showTutorial = ref(false);

async function fetchHabitHistories(date) {
  const data = await fetchWithAuth(`${API_URL}/users/${userId.value}/habit_histories?date=${date}`);
  const histories = await data;

  if (savedHabits) {
    savedHabits.value = new Set(
      histories.filter((h) => h.completed).map((h) => h.habit_id)
    );
  }
}

async function saveHabit(habitId) {
  const date = new Date().toISOString().split("T")[0];

  // Save the checked habit
  const habitHistory = {
    habit_id: habitId,
    user_id: userId.value,
    date: date,
    completed: true,
  };

  try {
    const response = await fetchWithAuth(
      `${API_URL}/habit_histories`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify([habitHistory]),
    },
      true
    );

    if (!response.ok) {
      showToast("Error saving habit!", "error");
      return;
    }

    showToast("Save successful", "success");
    setTimeout(() => {
      location.reload();
    }, 500);
  } catch (error) {
    console.error("There was a problem with the save operation:", error);
    showToast("Error saving habit!", "error");
  }
}

const sortedHabits = computed(() => {
  return [...habits.value]
    .filter((habit) => !habit.is_timed)
    .sort((a, b) => {
      const aSaved = savedHabits.value.has(a.id);
      const bSaved = savedHabits.value.has(b.id);
      if (aSaved === bSaved) return 0;
      return aSaved ? 1 : -1;
    });
});

const fetchHabits = async () => {
  if (userId.value != null) {
    try {
      const data = await fetchWithAuth(`${API_URL}/users/${userId.value}/habits`);
      if (!data) {
        showToast("Failed to fetch habits!", "error");
        return;
      }
      habits.value = await data;
    } catch (error) {
      showToast("Failed to fetch habits!", "error");
      console.error(error);
    }
  }
};

onMounted(async () => {
  isLoading.value = true;
  await fetchHabitHistories(new Date());
  await fetchHabits();
  isLoading.value = false;
});
</script>

<style scoped>
.section-box {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.habit-action-row {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 10px;
  padding: 8px 0;
}

.habit-description {
  font-size: 1.1rem;
  color: black;
  width: 100%;
  text-align: left;
}

.checked-border {
  border: 6px solid #4caf50;
}
</style>
