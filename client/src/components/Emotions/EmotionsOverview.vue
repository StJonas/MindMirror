<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/brain.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Emotions</h2>
        <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      </div>
      <router-link v-if="userId" to="/EmotionsLog" style="pointer-events: auto">
        <button type="button" :disabled="isEditMode">
          <img src="/log.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
        </button>
      </router-link>
    </div>

    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use Emotions</h3>
        <ul>
          <li>On this page you can do emotion journaling.</li>
          <li>Select a <b>pleasant</b> or <b>unpleasant</b> emotion by clicking on it.</li>
          <li>You can expand or collapse the emotion groups using the <b>+</b> or <b>−</b> button.</li>
          <li>Optionally, write your thoughts in the text field below.</li>
          <li>
            Click the
            <img src="/save.svg" alt="Save" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Save</b> button to save your entry.
          </li>
          <li>
            You can view your previous entries in the emotion history page
            <img src="/log.svg" alt="Log" class="icon" style="width: 20px; vertical-align: middle;" />
            .
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>

    <div v-if="userId" class="section-box">
      <h2 class="section-title">Select an emotion</h2>
      <div class="general-input">
        <div class="emotion-container">
          <div class="emotion-title-row">
            <span class="section-title" style="font-weight: bold;">Pleasant</span>
            <button @click="togglePleasant" class="toggle-btn">
              {{ showPleasant ? '−' : '+' }}
            </button>
          </div>
          <div v-if="showPleasant" class="emotions-row">
            <button v-for="emotion in pleasantEmotions" :key="emotion.id" class="emotion-btn"
              :class="{ active: selectedEmotion === emotion.id }" :style="{ backgroundColor: emotion.color }"
              @click="selectEmotion(emotion)">
              <i :class="emotion.icon" style="font-size: 2rem;"></i>
              <span style="margin-left: 8px; font-size: 1rem;">
                {{ emotion.name }}
              </span>
            </button>
          </div>
        </div>
        <div class="emotion-container">
          <div class="emotion-title-row">
            <span class="section-title" style="font-weight: bold;">Unpleasant</span>
            <button @click="toggleUnpleasant" class="toggle-btn">
              {{ showUnpleasant ? '−' : '+' }}
            </button>
          </div>
          <div v-if="showUnpleasant" class="emotions-row">
            <button v-for="emotion in unpleasantEmotions" :key="emotion.id" class="emotion-btn"
              :class="{ active: selectedEmotion === emotion.id }" :style="{ backgroundColor: emotion.color }"
              @click="selectEmotion(emotion)">
              <i :class="emotion.icon" style="font-size: 2rem;"></i>
              <span style="margin-left: 8px; font-size: 1rem;">
                {{ emotion.name }}
              </span>
            </button>
          </div>
        </div>

        <textarea type="text" v-model="emotionNote" name="site_notes" rows="5" class="general-input"
          placeholder="Write your thoughts here..." />
        <button @click="saveEmotionEntry" class="save-button">
          <img src="/save.svg" alt="Save" class="white-icon" style="width: 24px; height: 24px" />
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, ref, computed, onMounted } from "vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';
import { postLog } from '../../utils/loggerHelper';

const userId = inject("userId");
const API_URL = inject("API_URL");
const emotions = inject("emotions");
const showPleasant = ref(true);
const showUnpleasant = ref(true);
const isEditMode = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const selectedEmotion = ref(null);
const emotionNote = ref("");
const showTutorial = ref(false);

const pleasantEmotions = computed(() =>
  emotions.value.filter(e => e.category === 'pleasant')
);
const unpleasantEmotions = computed(() =>
  emotions.value.filter(e => e.category === 'unpleasant')
);

function selectEmotion(emotion) {
  selectedEmotion.value = emotion.id;
}

function togglePleasant() {
  showPleasant.value = !showPleasant.value;
}
function toggleUnpleasant() {
  showUnpleasant.value = !showUnpleasant.value;
}

async function saveEmotionEntry() {
  if (!selectedEmotion.value) {
    showToast("Please select an emotion", "info");
    return;
  }

  const res = await fetchWithAuth(
    `${API_URL}/emotion_log_entries`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        emotion_log_entry: {
          user_id: userId.value,
          date: new Date().toISOString().split("T")[0],
          emotion_id: selectedEmotion.value,
          content: emotionNote.value,
        },
      }),
    },
    true
  );

  if (res.ok) {
    showToast("Entry saved", "success");
    postLog({ event: "emotions_entry_saved", userId: userId.value, page: "EmotionsOverview", data: { emotionId: selectedEmotion.value, note: emotionNote.value } });

    selectedEmotion.value = null;
    emotionNote.value = "";

    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Error saving entry!", "error");
  }
}

onMounted(() => {
  postLog({ userId: userId.value, page: "EmotionsOverview" });
});
</script>

<style scoped>
.general-input {
  padding: 2px;
}

.emotions-row {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 1rem;
  width: 100%;
  background-color: #fff;
  border-radius: 8px;
  padding: 16px;
  box-sizing: border-box;
  justify-content: flex-start;
}

.emotion-btn {
  color: #fff;
  min-width: 80px;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: filter 0.2s;
  text-align: center;
  padding: 8px 16px;
  width: auto;
  max-width: 100%;
  white-space: nowrap;
}

.emotion-btn:hover {
  filter: brightness(1.1);
}

.emotion-btn.active {
  border: 2px solid #fff;
  box-shadow: 0 0 0 3px #fe712d;
}

.save-button {
  margin-left: 10px;
  margin-bottom: 10px;
}

.emotion-container {
  background-color: #cfe4ff;
  border-radius: 8px;
}

.emotion-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  gap: 12px;
}

@media (max-width: 600px) {
  .emotions-row {
    justify-content: center;
  }
}
</style>
