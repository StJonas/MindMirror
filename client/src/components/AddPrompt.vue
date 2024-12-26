<template>
  <div class="form-container">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Add Prompt</h2>
    </div>

    <div class="toggle-container">
      <span class="text-label">Daily Prompt</span>
      <!-- Textual label -->
      <div class="switch" @mousedown.prevent="">
        <input
          type="checkbox"
          id="isWeekly"
          v-model="is_weekly"
          @change="fetchPredefinedPrompts"
          class="checkbox"
        />

        <label for="isWeekly" class="label"></label>
      </div>
      <span class="text-label">Weekly Prompt</span>
    </div>
    <select v-model="selectedPrompt" @change="updatePrompt" class="name-input">
      <option value="" disabled>Select predefined prompt</option>
      <option
        v-for="prompt in predefinedPrompts"
        :key="prompt.id"
        :value="prompt.title"
      >
        {{ prompt.title }}
      </option>
    </select>
    <input
      type="text"
      v-model="prompt"
      placeholder="prompt"
      class="name-input"
    />

    <button v-if="isEditing" @click="updateHabit">Update</button>
    <button v-if="isEditing" @click="cancelEdit">Cancel</button>

    <button v-else @click="createPrompt" class="create-button">Create</button>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue"; //habit

const isEditing = ref(false);
const is_weekly = ref(false);
const API_URL = "http://localhost:3000/prompts";
const userId = inject("userId");
const prompt = ref("");
const selectedPrompt = ref("");
const emit = defineEmits(["navigateBackToJournal"]);
const predefinedPrompts = ref([]);
import router from "../router";

const fetchPredefinedPrompts = async () => {
  const res = await fetch(
    `${API_URL}?predefined=true&weekly=${is_weekly.value}`
  );
  predefinedPrompts.value = await res.json();
};

onMounted(() => {
  fetchPredefinedPrompts();
});

const updatePrompt = () => {
  prompt.value = selectedPrompt.value;
};

const createPrompt = async () => {
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      title: prompt.value,
      user_id: userId.value,
      weekly: is_weekly.value,
      predefined: false,
    }),
  });

  if (res.ok) {
    prompt.value = "";
    router.push("/");
  } else {
    const errorData = await res.json();
    console.error("Error creating prompt:", errorData);
  }
};

const goBack = () => {
  emit("navigateBackToJournal");
};
</script>

<style scoped>
.header-row {
  display: flex;
  align-items: center;
  gap: 20px;
}
.form-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-left: 30px;
}
.create-button {
  margin-top: 20px;
  margin-bottom: 20px;
}
.name-input {
  width: 500px;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
  font-size: 18px;
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

.form-container button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
