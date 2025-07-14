<template>
  <div class="page-styling">
    <div class="header-row">
      <h2 v-if="userId">{{ currentDate }}</h2>
      <router-link
        v-if="userId"
        to="/RechargeLog"
        style="pointer-events: auto"
      >
        <button type="button" :disabled="isEditMode">
          <img
            src="/log.svg"
            alt="Log"
            class="icon"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
    </div>

    <div v-if="userId" class="section-box">
      <h1 class="section-title">Daily recharge exercise</h1>
      <div class="general-input">
        <div class="header-row">
          <h3 v-if="currentExercise">{{ currentExercise.title }}</h3>
          <button @click="showRandomExercise" class="">
            <img src="/shuffle.svg" alt="Shuffle" class="icon" style="width: 24px; height: 24px" />
          </button>
        </div>
        
        <p v-if="currentExercise">{{ currentExercise.description }}</p>
        <textarea
          type="text"
          v-model="exerciseNote"
          name="site_notes"
          rows="5"
          class="general-input"
          placeholder="Reflect on the exercise..."
        />
        <button class="save-button" @click="saveEmotionEntry()">
          Done
        </button>
      </div>
    </div>
    
    </div>
</template>

<script setup>
import { inject, ref, onMounted } from "vue";

const userId = inject("userId");
const API_URL = inject("API_URL");
const exercises = ref([]);
const isEditMode = ref(false);
const currentExercise = ref(null);
const exerciseNote = ref(null);
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const fetchExercises = async () => {
  const res = await fetch(`${API_URL}/recharge_exercises`);
  if (res.ok) {
    exercises.value = await res.json();
    showRandomExercise();
  } else {
    console.error("Failed to fetch recharge exercises");
    return [];
  }
};

function showRandomExercise() {
  if (exercises.value.length > 0) {
    const idx = Math.floor(Math.random() * exercises.value.length);
    currentExercise.value = exercises.value[idx];
  } else {
    currentExercise.value = null;
  }
}

async function saveEmotionEntry() {
  if (!currentExercise.value) {
    alert("No exercise selected.");
    return;
  }

  const res = await fetch(`${API_URL}/recharge_logs`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      user_id: userId.value,
      date: new Date().toISOString().split("T")[0],
      exercise: currentExercise.value.title,
      completed: true,
      note: exerciseNote.value
    }),
  });

  if (res.ok) {
    alert("Exercise saved!");
    showRandomExercise();
    exerciseNote.value = ""; 
    window.location.reload();
  } else {
    const errorData = await res.json();
    alert("Error saving entry: " + (errorData.error || "Unknown error"));
  }
}

onMounted(() => {
  fetchExercises();
});
</script>

<style scoped>
.emotions-row {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 1rem;
}
.emotion-btn {
  color: #fff;
  width: 80px;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: filter 0.2s;
  text-align: center;
}
.emotion-btn:hover {
  filter: brightness(1.1);
}
.emotion-btn.active {
  border: 2px solid #fff;
  box-shadow: 0 0 0 3px #fe712d;
}
.save-button {
  margin: 0;
}

@media (max-width: 600px) {
}
</style>
