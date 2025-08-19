<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row-log">
      <router-link to="/JournalOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Add Question</h2>
    </div>
    <div class="general-input">
      <select v-model="selectedPrompt" @change="updatePrompt" class="general-input">
        <option value="" disabled>Select predefined question</option>
        <option v-for="prompt in filteredPredefinedPrompts" :key="prompt.id" :value="prompt.title">
          {{ prompt.title }}
        </option>
      </select>
      <input type="text" v-model="prompt" placeholder="write your own question" class="general-input" />

      <button @click="createPrompt" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject, computed } from "vue";
import router from "../../router";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';
import { postLog } from "../../utils/loggerHelper.js";

const is_weekly = ref(false);
const userId = inject("userId");
const prompt = ref("");
const selectedPrompt = ref("");
const emit = defineEmits(["navigateBackToJournal"]);
const API_URL = inject("API_URL");
const predefinedPrompts = ref([]);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const fetchPredefinedPrompts = async () => {
  const data = await fetchWithAuth(`${API_URL}/prompts?predefined=true`);
  predefinedPrompts.value = await data;
  if (!data) {
    showToast("Error fetching predefined questions", "error");
  }
};

const filteredPredefinedPrompts = computed(() => {
  return predefinedPrompts.value.filter(
    (prompt) => prompt.weekly === is_weekly.value
  );
});

const updatePrompt = () => {
  prompt.value = selectedPrompt.value;
};

const createPrompt = async () => {
  const res = await fetchWithAuth(`${API_URL}/prompts`,
    {
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
    },
    true
  );

  if (res.ok) {
    prompt.value = "";

    showToast("Question saved", "success");
    postLog({ event: "prompt_saved", userId: userId.value, page: "AddPrompt", data: { promptTitle: prompt.value } });

    setTimeout(() => {
      router.push("/JournalOverview").then(() => {
        window.location.reload();
      });
    }, 500);
  } else {
    showToast("Error creating question", "error");
  }
};

onMounted(() => {
  postLog({ userId: userId.value, page: "AddPrompt" });
  fetchPredefinedPrompts();
});
</script>

<style scoped>
@media (max-width: 600px) {}
</style>
