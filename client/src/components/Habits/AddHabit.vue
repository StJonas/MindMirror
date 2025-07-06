<template>
  <div class="form-container">
    <div class="header-row">
      <router-link to="/HabitOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Add Habit</h2>
    </div>

    <!-- Create or Habit -->
    <input
      type="text"
      v-model="name"
      placeholder="Name"
      class="general-input"
    />

    <div class="toggle-container">
      <span class="text-label">Timed Habit</span>
      <!-- Textual label -->
      <div class="switch" @mousedown.prevent="">
        <input
          type="checkbox"
          id="isTimed"
          v-model="is_timed"
          class="checkbox"
        />
        <label for="isTimed" class="label"></label>
        <!-- Switch UI -->
      </div>
    </div>
    <input
      type="number"
      v-model="frequency"
      placeholder="Frequency"
      class="general-input"
      v-if="!is_timed"
    />
    <!-- <select v-model="category" class="name-input">
      <option value="1">relationships</option>
      <option value="7">work</option>
      <option value="0">hobbies</option>
    </select> -->

    <button v-if="isEditing" @click="updateHabit">Update</button>
    <button v-if="isEditing" @click="cancelEdit">Cancel</button>

    <button @click="createHabit" class="save-button">
      <img src="/save.svg" alt="Save" class="white-icon" />
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue"; //habit
import router from "../../router";

const name = ref("");
const frequency = ref("");
const isEditing = ref(false);
const is_timed = ref(false);
const userId = ref("");
const API_URL = inject("API_URL");

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
      frequency: frequency.value,
      user_id: userId.value,
      is_timed: is_timed.value,
    }),
  });

  name.value = "";
  frequency.value = "";
  is_timed.value = false;
  router.push("/");
};
</script>

<style scoped></style>
