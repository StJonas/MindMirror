<template>
  <div>
    <h1>Add Habit</h1>

    <!-- Create or Habit -->
    <input type="text" v-model="name" placeholder="Name" class="name-input" />
    <input
      type="number"
      v-model="frequency"
      placeholder="Frequency"
      class="body-input"
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
    <button v-else @click="createHabit">Create</button>

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
const API_URL = "http://localhost:3000/habits";
const userId = ref("");

onMounted(async () => {
  const res = await fetch(API_URL);
  userId.value = localStorage.getItem("userId");
});

const createHabit = async () => {
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: name.value,
      frequency: frequency.value,
      user_id: userId.value,
    }),
  });

  name.value = "";
  frequency.value = "";
  router.push("/");
};
</script>

<style scoped>
.name-input {
  width: 100%;
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
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}
</style>
