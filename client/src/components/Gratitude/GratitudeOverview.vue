<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side" style="gap: 10px;">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/heart.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Gratitude</h2>
      
        <router-link
          v-if="userId"
          to="/GratitudeLog"
          style="pointer-events: auto"
        >
          <button type="button" class="log-button">
            <img
              src="/log.svg"
              alt="Log"
              class="icon"
              style="width: 24px; height: 24px"
            />
          </button>
        </router-link>
      </div>
    </div>
    
    <transition-group name="card-move" tag="div"> 
      <div class="section-box" v-if="userId && showPrompts">
        <h2 class="section-title">Daily Gratitude Question</h2>
          <div v-if="prompts && prompts.length === 0" :key="'no-prompts'" class="general-input">
            <h2>No prompts yet</h2>
            <input
              v-model="newPromptTitle"
              placeholder="Create your first gratitude prompt"
              class="general-input"
            />
            <button @click="addPrompt" class="save-button">
              <img src="/save.svg" alt="Save" class="white-icon" />
            </button>
          </div>
          
            <GratitudeInput
              v-for="prompt in prompts"
              :key="prompt.id"
              :prompt="prompt"
              class="general-input"
            />
          
      </div>
    </transition-group>

  </div>
</template>

<script setup>
import { inject, ref, onMounted } from "vue";
import GratitudeInput from "./GratitudeInput.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';

const API_URL = inject("API_URL");
const userId = inject("userId");
const prompts = inject("gratitude_prompts", ref([]));
const newPromptTitle = ref("");;
const showPrompts = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);


const addPrompt = async () => {
  if (!newPromptTitle.value.trim()) {
    showToast("Please select an emotion", "info");
    return;
  }
  const res = await fetchWithAuth(`${API_URL}/gratitude_prompts`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title: newPromptTitle.value,
        user_id: userId.value,
        weekly: false,
        predefined: false,
      }),
    },
    true
  ); 

  if (res.ok) {
    showToast("Question added", "success");
    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Error saving question!", "error");
  }
};

onMounted(() => {
  setTimeout(() => {
    showPrompts.value = true;
  }, 400);
});

</script>

<style scoped>
.card-move-enter-active, .card-move-leave-active {
  transition: all 0.5s cubic-bezier(.55,0,.1,1);
}
.card-move-enter-from {
  opacity: 0;
  transform: translateY(40px) scale(0.95);
}
.card-move-enter-to {
  opacity: 1;
  transform: translateY(0) scale(1);
}
.card-move-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
}
.card-move-leave-to {
  opacity: 0;
  transform: translateY(40px) scale(0.95);
}
@media (max-width: 600px) {
}
</style>
