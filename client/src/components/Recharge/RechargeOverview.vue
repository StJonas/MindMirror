<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/battery.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Recharge</h2>
      </div>

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

    <div v-if="userId  && showPrompts" class="section-box">
      <h1 class="section-title">Daily recharge exercise</h1>
      <div class="general-input">
        <div class="content-row">
          <h3 v-if="currentExercise">{{ currentExercise.title }}</h3>
          <button @click="showRandomExercise" class="">
            <img src="/shuffle.svg" alt="Shuffle" class="icon" style="width: 24px; height: 24px" />
          </button>
        </div>

        <hr class="content-divider" />
        
        <p v-if="currentExercise">{{ currentExercise.description }}</p>
        <textarea
          type="text"
          v-model="exerciseNote"
          name="exercise_note"
          rows="5"
          class="general-input"
          placeholder="Reflect on the exercise..."
        />
        <button class="save-button" @click="saveRechargeEntry()">
          Done
        </button>
      </div>
    </div>

    </div>
</template>

<script setup>
import { inject, ref, onMounted } from "vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';

const userId = inject("userId");
const API_URL = inject("API_URL");
const exercises = ref([]);
const isEditMode = ref(false);
const currentExercise = ref(null);
const exerciseNote = ref(null);
const showPrompts = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const fetchExercises = async () => {
  const data = await fetchWithAuth(`${API_URL}/recharge_exercises`);
  if (data) {
    exercises.value = await data;
    showRandomExercise();
  } else {
    showToast("Failed to fetch exercises!", "error");
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

async function saveRechargeEntry() {
  const res = await fetchWithAuth(`${API_URL}/recharge_logs`, {
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
    },
    true
  );

  if (res.ok) {
    showRandomExercise();
    exerciseNote.value = ""; 

    showToast("Entry saved", "success");
    setTimeout(() => {
        location.reload();
    }, 500);
  } else {
    showToast("Error saving entry!", "error");
  }
}

onMounted(() => {
  fetchExercises();

  setTimeout(() => {
    showPrompts.value = true;
  }, 300);
});
</script>

<style scoped>

@media (max-width: 600px) {
}
</style>
