<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row" v-if="userId">
      <h2>{{ currentDate }}</h2>
      <router-link to="/AddHabit" style="pointer-events: auto">
        <button type="button">
          <img
            src="/add.svg"
            alt="Add"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <router-link to="/HabitLog" style="pointer-events: auto">
        <button type="button">
          <img
            src="/log.svg"
            alt="Log"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
    </div>
    <!-- List of Habits -->
    <transition-group name="card-move" tag="div">
      <div v-for="habit in sortedHabits" :key="habit.id" class="section-box">
          <div class="content-row">
            <h2 class="section-title">{{ habit.name }}</h2>
            <router-link
              :to="`/editHabit/${habit.id}`"
              style="pointer-events: auto"
            >
              <button type="button">
                <img
                  src="/edit.svg"
                  alt="Log"
                  class="icon"
                  style="width: 24px; height: 24px"
                />
              </button>
            </router-link>
          </div>
        <hr class="content-divider" />
        <div class="habit-action-row">
          <span class="habit-description">{{ habit.description }}</span>
          <button
            type="button"
            @click="saveHabit(habit.id)"
            :class="['save-habit-btn', { 'checked-button': savedHabits.has(habit.id) }]"
          >
            <img
              src="/save.svg"
              alt="Log"
              class="icon"
              style="width: 24px; height: 24px"
            />
          </button>
        </div>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";

import { inject, ref, onMounted, computed } from "vue";

const habits = ref([]);
const API_URL = inject("API_URL");
const userId = inject("userId");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const savedHabits = ref(new Set());

async function fetchHabitHistories(date) {
  const url = `${API_URL}/users/${userId.value}/habit_histories?date=${date}`;
  const res = await fetch(url);
  const histories = await res.json();

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
    const response = await fetch(`${API_URL}/habit_histories`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify([habitHistory]),
    });

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
      const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
      if (!res.ok) {
        showToast("Failed to fetch habits!", "error");
        console.error("HTTP error:", res.status, await res.text());
        return;
      }
      habits.value = await res.json();
    } catch (error) {
      showToast("Failed to fetch habits!", "error");
      console.error(error);
    }
  }
};

onMounted(async () => {
  fetchHabitHistories(new Date());
  fetchHabits();
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

.save-habit-btn {
  border-color: #007BFF;
}

</style>
