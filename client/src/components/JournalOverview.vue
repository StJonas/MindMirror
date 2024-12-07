<template>
  <div class="page-styling">
    <div class="header">
      <h2>Weekly Prompts</h2>
      <router-link to="/AddHabit" v-if="userId">
        <button type="button">Add Prompt</button>
      </router-link>

      <button v-if="userId" type="button" @click="navigateToJournalLog">
        Journal Log
      </button>

      <h3>13. Dez 2024</h3>
    </div>
    <div>
      <span>{{ weeklyPrompt }}</span>
      <input type="text" placeholder="input" min="1" class="styled-input" />
    </div>
    <div class="header">
      <h2>Daily Prompts</h2>
      <router-link to="/AddHabit" v-if="userId">
        <button type="button">Add Prompt</button>
      </router-link>
      <button v-if="userId" type="button" @click="navigateToJournalLog">
        Journal Log
      </button>
    </div>
    <div>
      <span>{{ dailyPrompt }}</span>
      <input type="text" placeholder="input" min="1" class="styled-input" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, defineEmits, inject } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = inject("userId");
const weeklyPrompt = ref("weekly prompt");
const dailyPrompt = ref("daily prompt");
const emit = defineEmits(["navigateToJournalLog"]);

const navigateToJournalLog = () => {
  emit("navigateToJournalLog");
};
</script>

<style scoped>
.page-styling {
  margin-left: 0;
}
.header {
  display: flex;
  align-items: center;
  gap: 30px;
  margin-left: -90px;
}

.header button {
  margin-left: 200px;
  position: relative;
}

.header h3 {
  margin-left: 1000px;
  position: absolute;
}

.styled-input {
  width: 500px;
  height: 80px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  color: #333;
  margin-left: 20px;
}

.page-styling button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
