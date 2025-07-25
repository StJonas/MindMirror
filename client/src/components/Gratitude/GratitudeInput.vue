<template>
  <div class="section-box">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="content-row">
      <h2>{{ prompt.title }}</h2>
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
      <button @click="deletePrompt" v-if="isEditMode" class="delete-button">
        <img
          src="/delete.svg"
          alt="Delete"
          class="white-icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
    <hr class="content-divider" />
    <div v-if="isEditMode && !new_question">
      <select v-model="selectedPromptId" class="general-input">
        <option
          v-for="prompt in predefinedGratitudePrompts"
          :key="prompt.id"
          :value="prompt.id"
        >
          {{ prompt.title }}
        </option>
      </select>
      <button
        v-if="selectedPromptId"
        @click="updatePrompt(props.prompt.id, predefinedGratitudePrompts.find(p => p.id === selectedPromptId)?.title)"
        class="save-button"
        style="margin-top: 8px;"
      >
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
    <div class="" v-if="isEditMode">
      <div class="toggle-container">
        <span class="text-label">update current question</span>
        <!-- Textual label -->
        <div class="" @mousedown.prevent="">
          <input
            type="checkbox"
            id="isWeekly"
            v-model="new_question"
            @change="updatepredefinedGratitudePrompts"
            class="checkbox"
          />

          <label for="isWeekly" class="label"></label>
        </div>
      </div>
    </div>
    <div v-if="!isEditMode">
      <textarea type="text" 
          v-model="prompt.content"
          rows="5" 
          class="general-input" 
          placeholder="Your answer..."
          />

      <div v-if="!isEditMode">
        <button
          v-if="userId"
          type="button"
          @click="saveGratitudeEntry(prompt.content)"
          class="save-button"
        >
          <img src="/save.svg" alt="Save" class="white-icon" />
        </button>
      </div>
    </div>
    <div v-if="new_question && isEditMode" class="add-prompt-row">
      <input v-model="editablePromptTitle" class="general-input" />
        <button @click="updatePrompt(props.prompt.id, editablePromptTitle)" class="save-button">
          <img src="/save.svg" alt="Save" class="white-icon" style="width: 24px; height: 24px" />
        </button>
    </div>
  </div>
</template>

<script setup>
import { inject, ref, onMounted, watch } from "vue";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { fetchWithAuth } from '../../utils/apiHelpers';

const props = defineProps({
  prompt: Object,
  required: true,
});
const API_URL = inject("API_URL");
const prompts = inject("gratitude_prompts");
const userId = inject("userId");
const isEditMode = ref(false);
const selectedPromptId = ref(prompts.value[0]?.id || null);
const showAddPrompt = ref(false);
const new_question = ref(false);
const entries = inject("gratitude_entries");
const editablePromptTitle = ref(props.prompt.title);
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const predefinedGratitudePrompts = ref([]);

function toggleEditMode() {
  isEditMode.value = !isEditMode.value;
  showAddPrompt.value = !showAddPrompt.value;
}

const updatePrompt = async (promptId, newTitle) => {
  const res = await fetchWithAuth(`${API_URL}/gratitude_prompts/${promptId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title: newTitle,
        user_id: userId.value,
        weekly: false,
        predefined: false,
      }),
    },
    true
  );

  if (res.ok) {
    showToast("Question updated", "success");
    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Update error", "error");
  }
};

const deletePrompt = async () => {
  if (confirm("Are you sure you want to delete this question?")) {
    const res = await fetchWithAuth(`${API_URL}/gratitude_prompts/${props.prompt.id}`, {
        method: "DELETE",
      },
      true
    );

    if (res.ok) {
      showToast("Quetion deleted successfully", "success");
      setTimeout(() => {
        location.reload();
      }, 500);
    } else {
      showToast("Error deleting Quetion", "error");
    }
  }
};

const saveGratitudeEntry = async (content) => {
  const today = new Date();
  const entryDate = today.toISOString().split("T")[0];

  // Find existing entry for the prompt
  let existingEntry = null;
  if (props.prompt.weekly) {
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday

    existingEntry = entries.value.find(
      (entry) =>
        entry.gratitude_prompt_id === props.prompt.id &&
        new Date(entry.entry_date) >= startOfWeek &&
        new Date(entry.entry_date) <= endOfWeek
    );
  } else {
    existingEntry = entries.value.find(
      (entry) =>
        entry.gratitude_prompt_id === props.prompt.id &&
        entry.entry_date === entryDate
    );
  }

  // If an existing entry is found, update it; otherwise, create a new entry
  if (existingEntry) {
    const updateRes = await fetchWithAuth(
      `${API_URL}/gratitude_entries/${existingEntry.id}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          content: content,
        }),
      },
      true
    );

    if (updateRes.ok) {
      showToast("Gratitude entry updated", "success");
      setTimeout(() => {
        window.location.reload();
      }, 500);
    } else {
      const errorData = await updateRes.json();
      console.error("Error updating gratitude entry:", errorData);
      showToast("Error updating gratitude entry", "error");
    }
  } else {
    const createRes = await fetchWithAuth(`${API_URL}/gratitude_entries`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          content: content,
          entry_date: entryDate,
          user_id: userId.value,
          gratitude_prompt_id: props.prompt.id,
          prompt_title: props.prompt.title,
        }),
      },
      true
    );

    if (createRes.ok) {
      showToast("Gratitude entry saved", "success");
      setTimeout(() => {
        window.location.reload();
      }, 500);
    } else {
      const errorData = await createRes.json();
      console.error("Error saving gratitude entry:", errorData);
      showToast("Error saving gratitude entry", "error");
    }
  }
};

const fetchUnusedPredefinedPrompts = async () => {
  try {
    const data = await fetchWithAuth(`${API_URL}/gratitude_prompts?predefined=true`);
    if (!data) {
      showToast("Failed to fetch predefined prompts", "error");
      return [];
    }
    const allPredefined = await data;

    const userPrompts = await fetchWithAuth(`${API_URL}/users/${userId.value}/gratitude_prompts`);
    if (!userPrompts) {
      showToast("Failed to fetch user prompts", "error");
      return [];
    }
    const userPromptTitles = userPrompts.map(p => p.title);

    return allPredefined.filter(p => !userPromptTitles.includes(p.title));
  } catch (error) {
    showToast("Error fetching prompts", "error");
    return [];
  }
};

watch(
  () => props.prompt.title,
  (newTitle) => {
    editablePromptTitle.value = newTitle;
  }
);

onMounted(async () => {
  predefinedGratitudePrompts.value = await fetchUnusedPredefinedPrompts();
});
</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
