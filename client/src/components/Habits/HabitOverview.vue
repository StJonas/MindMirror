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
        <div class="header-row">
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
        <div class="general-input">
          <span>{{ habit.description }}</span>
          <button
            type="button"
            @click="saveHabit(habit.id)"
            :class="['', { 'checked-button': savedHabits.has(habit.id) }]"
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

import { inject, ref, onMounted, computed } from "vue";

const habits = ref([]);
const API_URL = inject("API_URL");
const userId = inject("userId");
const toastRef = ref(null);
const toastType = ref("success");
const toastMessage = ref("Habit saved successfully!");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const savedHabits = ref(new Set());

const handleSaveSuccess = (habitId) => {
  toastMessage.value = "Habit saved successfully!";
  toastType.value = "success";
  if (toastRef.value && typeof toastRef.value.show === "function") {
    toastRef.value.show();
  }
};

const handleSaveFailure = (error) => {
  toastMessage.value = "Error saving habit!";
  toastType.value = "error";
  if (toastRef.value && typeof toastRef.value.show === "function") {
    toastRef.value.show();
  }
};

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
      handleSaveFailure(habitId);
      return;
    }

    const data = await response.json();
    console.log("Save successful", data);
    handleSaveSuccess(habitId);
    window.location.reload();
  } catch (error) {
    console.error("There was a problem with the save operation:", error);
    handleSaveFailure(habitId);
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
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }
};

onMounted(async () => {
  fetchHabitHistories(new Date());
  fetchHabits();
});
</script>

<style scoped>
.card-move-move {
  transition: transform 0.4s cubic-bezier(0.55, 0, 0.1, 1);
}
.card-move-enter-active,
.card-move-leave-active {
  transition: all 0.4s cubic-bezier(0.55, 0, 0.1, 1);
}
.card-move-enter-from,
.card-move-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
