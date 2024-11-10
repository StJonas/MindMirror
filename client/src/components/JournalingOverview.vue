<template>
  <div class="page-styling">
    <div class="header">
      <h2>Journaling</h2>
      <router-link to="/AddHabit" v-if="userId">
        <button type="button">Add Prompt</button>
      </router-link>
      <span>{{ weeklyPrompt }}</span>
      <input type="text" placeholder="input" min="1" class="styled-input" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const weeklyPrompt = ref("weekly prompt");

onMounted(async () => {
  userId.value = localStorage.getItem("userId");
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }
});
</script>

<style scoped>
.page-styling {
  margin-left: 0px;
}
.header {
  align-content: center;
}
.styled-input {
  width: 100px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  color: #333;
  margin-left: 20px;
}
</style>
