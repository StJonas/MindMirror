<template>
  <div class="page-styling">
    <div class="header">
      <h2>{{ currentDate }}</h2>
      <button v-if="userId" type="button" @click="navigateToAddPrompt">
        Add Prompt
      </button>
      <button v-if="userId" type="button" @click="navigateToJournalLog">
        Journal Log
      </button>
      <button
        v-if="userId"
        type="button"
        @click="navigateToEditPrompts"
        class="edit-button"
      >
        <img
          src="/public/edit.svg"
          alt="Edit"
          class="icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
    <div class="header">
      <h2>Weekly Prompts</h2>
    </div>
    <div>
      <span>{{ weeklyPrompt }}</span>
      <input type="text" placeholder="input" min="1" class="styled-input" />
    </div>
    <div class="header">
      <h2>Daily Prompts</h2>
    </div>
    <div>
      <span>{{ dailyPrompt }}</span>
      <input type="text" placeholder="input" min="1" class="styled-input" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = inject("userId");
const weeklyPrompt = ref("weekly prompt");
const dailyPrompt = ref("daily prompt");
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const navigateToJournalLog = () => {
  emit("navigateToJournalLog");
};

const navigateToAddPrompt = () => {
  emit("navigateToAddPrompt");
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

.edit-button {
  width: 60px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
