<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <div class="side-by-side">
        <router-link to="/">
          <button type="button" class="back-btn">&lt;</button>
        </router-link>
        <img src="/pen.svg" alt="Shuffle" class="icon" style="width: 36px; height: 36px" />
        <h2 class="header-row-title">Freetext</h2>
        <button class="help-btn" @click="showTutorial = true" title="Show help">?</button>
      </div>
      <router-link v-if="userId" to="/FreetextLog" :class="{ 'disabled-button': isEditMode }"
        :tabindex="isEditMode ? -1 : 0" aria-disabled="isEditMode" style="pointer-events: auto">
        <button type="button" :disabled="isEditMode">
          <img src="/log.svg" alt="Log" class="icon" style="width: 24px; height: 24px" />
        </button>
      </router-link>
    </div>
    <div v-if="showTutorial" class="tutorial-modal">
      <div class="tutorial-content">
        <h3>How to use the Freetext-Page</h3>
        <ul>
          <li>Write your thoughts or notes in the text field</li>
          <li>Check the "done offline" box if you made the entry offline</li>
          <li>
            Click the
            <img src="/save.svg" alt="Save" class="icon" style="width: 20px; vertical-align: middle;" />
            <b>Save</b> button to save your entry
          </li>
          <li>
            You can find your past entries on the history page
            <img src="/log.svg" alt="Log" class="icon" style="width: 20px; vertical-align: middle;" />
          </li>
        </ul>
        <button @click="showTutorial = false" class="close-btn">Close</button>
      </div>
    </div>
    <div class="section-box" v-if="userId">
      <div class="side-by-side">
        <h2 class="section-title">Freetext</h2>
      </div>
      <div class="general-input">
        <textarea type="text" name="site_notes" v-model="freetextContent" rows="5" class="general-input"
          placeholder="Write your thoughts here..." :disabled="doneOffline" :class="{ 'greyed-out': doneOffline }" />
        <div class="toggle-container">
          <span class="text-label">done offline</span>
          <div>
            <input type="checkbox" id="doneOffline" v-model="doneOffline" class="checkbox" />
            <label for="doneOffline" class="label"></label>
          </div>
        </div>
        <button @click="saveFreetextEntry" class="save-button">
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

const userId = inject("userId");
const isEditMode = ref(false);
const API_URL = inject("API_URL");
const doneOffline = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const freetextContent = ref("");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);
const showTutorial = ref(false);

const saveFreetextEntry = async () => {
  const res = await fetchWithAuth(`${API_URL}/users/${userId.value}/freetext_entries`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      freetext_entry: {
        user_id: userId.value,
        content: freetextContent.value,
        date: new Date().toISOString().split("T")[0],
        done_offline: doneOffline.value
      }
    }),
  },
    true
  );

  if (res.ok) {
    freetextContent.value = "";
    doneOffline.value = false;

    showToast("Freetext entry saved", "success");
    setTimeout(() => {
      location.reload();
    }, 500);
  } else {
    showToast("Error saving entry!", "error");
  }
};

onMounted(() => {
  if (!localStorage.getItem("freetext_tutorial_seen")) {
    showTutorial.value = true;
    localStorage.setItem("freetext_tutorial_seen", "1");
  }
});

</script>

<style scoped>
@media (max-width: 600px) {}
</style>
