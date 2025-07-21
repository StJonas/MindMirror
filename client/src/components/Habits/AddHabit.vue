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
      <input
        type="text"
        v-model="name"
        placeholder="Habit title"
        class="general-input"
      />

      <input
        type="text"
        v-model="description"
        placeholder="Description"
        class="general-input"
        v-if="!is_timed"
      />

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

const name = ref("");
const frequency = ref("");
const description = ref("");
const isEditing = ref(false);
const is_timed = ref(false);
const userId = ref("");
const API_URL = inject("API_URL");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

onMounted(async () => {
  userId.value = localStorage.getItem("userId");
});

const createHabit = async () => {
  if (is_timed.value) {
    frequency.value = 0;
  }
  console.log("is_timed.value", is_timed.value);
  const res = await fetch(`${API_URL}/habits`, {
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
  });

  if (res.ok) {
    showToast("Habit created successfully!", "success");
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
</script>

<style scoped></style>
