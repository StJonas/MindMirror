<template>
  <div class="form-container">
    <h1>Add Habit</h1>

    <!-- Create or Habit -->
    <input type="text" v-model="name" placeholder="Name" class="name-input" />

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
      class="body-input"
      v-if="!is_timed"
    />
    <!-- <select v-model="category" class="name-input">
      <option value="1">relationships</option>
      <option value="7">work</option>
      <option value="0">hobbies</option>
    </select> -->

    <!-- only render if editing habit -->
    <button v-if="isEditing" @click="updateHabit">Update</button>
    <button v-if="isEditing" @click="cancelEdit">Cancel</button>

    <!-- only render if not editing habit -->
    <button v-else @click="createHabit" class="create-button">Create</button>

    <button type="button">
      <router-link to="/">Go Back</router-link>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue"; //habit
import router from "../router";

const name = ref("");
const frequency = ref("");
const habit_id = ref(0);
const isEditing = ref(false);
const is_timed = ref(false);
const API_URL = "http://localhost:3000/habits";
const userId = ref("");

onMounted(async () => {
  const res = await fetch(API_URL);
  userId.value = localStorage.getItem("userId");
});

const createHabit = async () => {
  if (is_timed.value) {
    frequency.value = 0;
  }
  console.log("is_timed.value", is_timed.value);
  const res = await fetch(API_URL, {
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

<style scoped>
.form-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
.create-button {
  margin-top: 20px;
  margin-bottom: 20px;
}
.name-input {
  width: 300px;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}

.body-input {
  width: 300px;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}

.toggle-switch {
  margin: 20px 0;
}
.checkbox {
  opacity: 0;
  position: fixed;
  width: 0;
}
.label {
  background-color: #ccc;
  border-radius: 20px;
  cursor: pointer;
  display: inline-block;
  height: 24px;
  position: relative;
  width: 48px;
  margin-top: 10px;
  margin-bottom: 10px;
}
.label:after {
  background-color: #fff;
  border-radius: 20px;
  content: "";
  height: 20px;
  left: 2px;
  position: absolute;
  top: 2px;
  transition: 0.2s;
  width: 20px;
}
.checkbox:checked + .label {
  background-color: #66bb6a;
}
.checkbox:checked + .label:after {
  transform: translateX(24px);
}
.toggle-container {
  display: flex;
  align-items: center;
  gap: 10px; /* gap between elements */
}
.text-label {
  position: relative;
  top: -3px; /* move label higher or lower */
}
</style>
