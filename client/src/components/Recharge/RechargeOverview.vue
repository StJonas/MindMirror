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
        <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      </div>

      <router-link v-if="userId" to="/RechargeLog" style="pointer-events: auto">
        <button type="button" :disabled="isEditMode">
          <img src="/log.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
        </button>
      </router-link>
    </div>

    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use Recharge</h3>
        <ul>
          <li>This pages offers you different recharge exercises.</li>
          <li>Click the
            <img src="/shuffle.svg" alt="Shuffle" class="icon" style="width: 20px; vertical-align: middle;" />
            button to get a new random exercise.
          </li>
          <li>Optionally write your thoughts or notes in the text field below the exercise.</li>
          <li>
            Click the
            <img src="/save.svg" alt="Save" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Save</b> button to save your entry.
          </li>
          <li>
            You can find your previous entries in the recharge history page
            <img src="/log.svg" alt="Log" class="icon" style="width: 20px; vertical-align: middle;" />
            .
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>

    <div v-if="userId && showPrompts" class="section-box">
      <div class="side-by-side">
        <h1 class="section-title">Daily recharge exercise</h1>
      </div>
      <div class="general-input">
        <div class="content-row">
          <h3 v-if="currentExercise">{{ currentExercise.title }}</h3>
          <button @click="showRandomExercise" class="">
            <img src="/shuffle.svg" alt="Shuffle" class="icon" style="width: 24px; height: 24px" />
          </button>
        </div>

        <hr class="content-divider" />

        <p v-if="currentExercise">{{ currentExercise.description }}</p>
        <textarea type="text" v-model="exerciseNote" name="exercise_note" rows="5" class="general-input"
          placeholder="Optionally reflect on the exercise..." />
        <button class="save-button" @click="saveRechargeEntry()">
          <img src="/save.svg" alt="Save" class="white-icon" style="width: 24px; height: 24px" />
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
import { postLog } from "../../utils/loggerHelper.js";

const userId = inject("userId");
const API_URL = inject("API_URL");
const exercises = ref([]);
const isEditMode = ref(false);
const currentExercise = ref(null);
const exerciseNote = ref(null);
const showPrompts = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const showTutorial = ref(false);

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
    showToast("Entry saved", "success");
    postLog({ event: "recharge_entry_saved", userId: userId.value, page: "RechargeOverview", data: { exercise: currentExercise.value.title, note: exerciseNote.value } });

    showRandomExercise();
    exerciseNote.value = "";

    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Error saving entry!", "error");
  }
}

onMounted(() => {
  fetchExercises();
  postLog({ userId: userId.value, page: "RechargeOverview" });

  setTimeout(() => {
    showPrompts.value = true;
  }, 300);
});
</script>

<style scoped>
@media (max-width: 600px) {}
</style>
