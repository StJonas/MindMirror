<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="">
      <div class="header-row">
        <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/book.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Journal</h2>
      </div>
      <div class="side-by-side">
          <router-link
            v-if="userId"
            to="/addPrompt"
            :class="{ 'disabled-button': isEditMode }"
            :tabindex="isEditMode ? -1 : 0"
            aria-disabled="isEditMode"
            style="pointer-events: auto"
          >
            <button type="button" :disabled="isEditMode">
              <img
                src="/add.svg"
                alt="Add"
                class="icon"
                style="width: 24px; height: 24px"
              />
            </button>
          </router-link>
        <router-link
          v-if="userId"
          to="/journalLog"
          :class="{ 'disabled-button': isEditMode }"
          :tabindex="isEditMode ? -1 : 0"
          aria-disabled="isEditMode"
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
      </div>
      
      <transition-group name="card-move" tag="div">
        <div class="section-box" v-if="userId && showPrompts"  :key="prompts.length ? 'has-prompts' : 'no-prompts'">
          <div class="header-row">
            <h2 class="section-title">Daily Journaling Questions</h2>
                    <button
            v-if="userId"
            type="button"
            @click="toggleEditMode"
            :class="['edit-button', { 'enabled-button': isEditMode }]"
            >
              <img
                src="/edit.svg"
                alt="Edit"
                class="icon"
                style="width: 24px; height: 24px"
              />
            </button>
          </div>

          <div class="">
            
              <template v-if="!isEditMode">
                <JournalInput
                  v-for="prompt in prompts.filter((p) => !p.weekly)"
                  :key="prompt.id"
                  :prompt="prompt"
                  class="general-input"
                />
              </template>

              <template v-else>
                <EditPrompt
                  v-for="prompt in prompts.filter((p) => !p.weekly)"
                  :key="prompt.id"
                  :prompt="prompt"
                  class="general-input"
                />
              </template>
            
          </div>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect, ref, onMounted } from "vue";
import JournalInput from "./JournalInput.vue";
import EditPrompt from "./EditPrompt.vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';

const userId = inject("userId");
const API_URL = inject("API_URL");
const prompts = ref([]);
const entries = inject("entries");
const isEditMode = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const showPrompts = ref(false);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const matchEntriesWithPrompts = () => {
  const today = new Date();
  const startOfWeek = new Date(today);
  startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
  const endOfWeek = new Date(startOfWeek);
  endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday

  prompts.value.forEach((prompt) => {
    const entry = entries.value.find((entry) => {
      const entryDate = new Date(entry.entry_date);
      if (prompt.id === entry.prompt_id) {
        if (prompt.weekly) {
          return entryDate >= startOfWeek && entryDate <= endOfWeek;
        } else {
          return entryDate.toDateString() === today.toDateString();
        }
      }
      return false;
    });

    if (entry) {
      prompt.content = entry.content;
    }
  });
};

const toggleEditMode = () => {
  isEditMode.value = !isEditMode.value;
};

const fetchPrompts = async () => {
  if (userId.value) {
    try {
      const data = await fetchWithAuth(`${API_URL}/users/${userId.value}/prompts`);

      prompts.value = await data;
      prompts.value.forEach((prompt) => {
        prompt.content = "";
      });
    } catch (error) {
      showToast("Failed to fetch exercises!", "error");
      console.error(error);
    }
  }
};

onMounted(() => {
  if (userId.value) {
    fetchPrompts();
  }
  setTimeout(() => {
    showPrompts.value = true;
  }, 400);
});

watchEffect(async () => {
  if (entries.value) {
    matchEntriesWithPrompts();
  }
});
</script>

<style scoped>

</style>
