<template>
  <div class="page-styling">
    <div class="header-row">
      <h2 v-if="userId">{{ currentDate }}</h2>
      <router-link
        v-if="userId"
        to="/FreetextLog"
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
    <div class="section-box" v-if="userId">
      <h2 class="section-title">Freetext</h2>
      <div class="general-input">
        <textarea type="text" 
          name="site_notes" 
          v-model="freetextContent"
          rows="5" 
          class="general-input" 
          placeholder="Write your thoughts here..."
          :disabled="doneOffline"
          :class="{ 'greyed-out': doneOffline }"
          />
        <div class="toggle-container">
          <span class="text-label">done offline</span>
          <div>
            <input
              type="checkbox"
              id="doneOffline"
              v-model="doneOffline"
              class="checkbox"
            />
            <label for="doneOffline" class="label"></label>
          </div>
        </div>
        <button @click="saveFreetextEntry" class="save-button">
          Save
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { inject, ref } from "vue";

const userId = inject("userId");
const isEditMode = ref(false);
const API_URL = inject("API_URL");
const doneOffline = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const freetextContent = ref("");
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

const saveFreetextEntry = async () => {
  const res = await fetch(`${API_URL}/users/${userId.value}/freetext_entries`, {
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
  });

  if (res.ok) {
    alert("Freetext entry saved!");
    freetextContent.value = "";
    doneOffline.value = false;
    window.location.reload();
  } else {
    const errorData = await res.json();
    alert("Error saving entry: " + (errorData.error || "Unknown error"));
  }
};

</script>

<style scoped>
@media (max-width: 600px) {
}
</style>
