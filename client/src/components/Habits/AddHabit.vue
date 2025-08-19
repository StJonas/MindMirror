<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row-log">
      <router-link to="/HabitOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Add Habit</h2>
    </div>
    <div class="section-box">
      <!-- Create or Habit -->
      <input type="text" v-model="name" placeholder="Habit title" class="general-input" />

      <input type="text" v-model="description" placeholder="Optional description" class="general-input"
        v-if="!is_timed" />

      <button v-if="isEditing" @click="updateHabit">Update</button>
      <button v-if="isEditing" @click="cancelEdit">Cancel</button>

      <button @click="createHabit" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue"; //habit
import router from "../../router";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';
import { postLog } from '../../utils/loggerHelper';

const name = ref("");
const frequency = ref("");
const description = ref("");
const isEditing = ref(false);
const is_timed = ref(false);
const userId = inject("userId");
const API_URL = inject("API_URL");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const createHabit = async () => {
  if (is_timed.value) {
    frequency.value = 0;
  }
  const res = await fetchWithAuth(`${API_URL}/habits`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: name.value,
      frequency: 0,
      user_id: userId.value,
      is_timed: is_timed.value,
      description: description.value
    }),
  },
    true
  );

  if (res.ok) {
    showToast("Habit created successfully!", "success");
    postLog({ event: "habit_created", userId: userId.value, page: "AddHabit", data: { habitName: name.value } });

    setTimeout(() => {
      name.value = "";
      frequency.value = "";
      is_timed.value = false;
      router.push("/HabitOverview").then(() => {
        window.location.reload();
      });
    }, 500);
  } else {
    showToast("Failed to create habit!", "error");
    const errorData = await res.json();
    console.error("Error creating habit:", errorData);
  }
};

onMounted(async () => {
  if (userId.value) {
    postLog({ userId: userId.value, page: "AddHabit" });
  }
});
</script>

<style scoped></style>
