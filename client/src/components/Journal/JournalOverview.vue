<template>
  <div class="page-styling">
    <div class="header">
      <h2 v-if="userId">{{ currentDate }}</h2>
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
    <div class="input-box" v-if="userId">
      <h2>Weekly Questions</h2>

      <template v-if="!isEditMode">
        <JournalInput
          v-for="prompt in prompts.filter((p) => p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="journal-input"
        />
      </template>

      <template v-else>
        <EditPrompt
          v-for="prompt in prompts.filter((p) => p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="journal-input"
        />
      </template>
    </div>
    <div class="input-box" v-if="userId">
      <h2>Daily Questions</h2>

      <template v-if="!isEditMode">
        <JournalInput
          v-for="prompt in prompts.filter((p) => !p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="journal-input"
        />
      </template>

      <template v-else>
        <EditPrompt
          v-for="prompt in prompts.filter((p) => !p.weekly)"
          :key="prompt.id"
          :prompt="prompt"
          class="journal-input"
        />
      </template>
    </div>
  </div>
</template>

<script setup>
import { inject, watchEffect, ref } from "vue";
import JournalInput from "./JournalInput.vue";
import EditPrompt from "./EditPrompt.vue";

const userId = inject("userId");
const prompts = inject("prompts");
const entries = inject("entries");
const isEditMode = ref(false);
const emit = defineEmits(["navigateToJournalLog", "navigateToAddPrompt"]);
const currentDate = new Date().toLocaleDateString("de-DE", {
  day: "2-digit",
  month: "long",
  year: "numeric",
});

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

const navigateToJournalLog = () => {
  emit("navigateToJournalLog");
};

const navigateToAddPrompt = () => {
  emit("navigateToAddPrompt");
};

const toggleEditMode = () => {
  isEditMode.value = !isEditMode.value;
};

watchEffect(async () => {
  if (entries.value) {
    matchEntriesWithPrompts();
  }
});
</script>

<style scoped>
.page-styling {
  margin-left: 0;
  margin-top: 40px;
}
.header {
  display: flex;
  align-items: center;
  gap: 30px;
  margin-left: 0px;
}

.header button {
  margin-left: 200px;
  position: relative;
}

.styled-input {
  width: 500px;
  height: 80px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  color: #333;
  margin-left: 20px;
}

.page-styling button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}

.edit-button {
  width: 24px;
  height: 24x;
  display: flex;
  justify-content: center;
  align-items: center;
}

.input-box {
  margin-left: 12px;
}

.disabled-button {
  background-color: #a9a9a9;
  cursor: not-allowed;
}

.enabled-button {
  background-color: orange;
}

@media (max-width: 600px) {
  .input-box {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    margin-bottom: 24px;
    height: auto;
    width: 100%;
  }
  .header {
    gap: 6px;
    margin-left: 5px;
    flex-wrap: wrap;
    width: 100%;
  }
  .header h2 {
    font-size: 1.3rem;
    margin-left: -10px;
    margin-top: 0;
    margin-bottom: 0;
  }
  .input-box h2 {
    font-size: 1.3rem;
    margin-top: 20px;
    margin-bottom: -10px;
  }
  .styled-input {
    width: 85vw;
    min-width: 0;
    height: 40px;
    font-size: 0.8rem;
    margin-left: 0;
  }
  .journal-input {
    width: 70vw;
    min-width: 0;
    font-size: 0.8rem;
    height: auto;
    background-color: rgb(70, 69, 69);
    border-radius: 12px;
    margin-top: 20px;
    padding: 3px;
    padding-left: 20px;
    padding-bottom: 20px;
  }
}
</style>
