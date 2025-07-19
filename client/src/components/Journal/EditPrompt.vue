<template>
  <div class="">
    <h2>Edit: {{ prompt.title }}</h2>
    <input
      type="text"
      v-model="promptTitle"
      placeholder="Prompt Title"
      class="general-input"
    />
    <div class="button-wrapper">
      <button @click="savePrompt" class="save-button">
        <img
          src="/save.svg"
          alt="Save"
          class="white-icon"
          style="width: 24px; height: 24px"
        />
      </button>
      <button @click="deletePrompt" class="delete-button">
        <img
          src="/delete.svg"
          alt="Delete"
          class="white-icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, inject } from "vue";

const props = defineProps({
  prompt: Object,
});

const promptTitle = ref(props.prompt.title);
const API_URL = inject("API_URL");

const savePrompt = async () => {
  const res = await fetch(`${API_URL}/prompts/${props.prompt.id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      title: promptTitle.value,
    }),
  });

  if (res.ok) {
    window.location.reload();
  } else {
    const errorData = await res.json();
    console.error("Error updating prompt:", errorData);
  }
};

const deletePrompt = async () => {
  if (confirm("Are you sure you want to delete this prompt?")) {
    const res = await fetch(`${API_URL}/prompts/${props.prompt.id}`, {
      method: "DELETE",
    });

    if (res.ok) {
      window.location.reload();
    } else {
      const errorData = await res.json();
      console.error("Error deleting prompt:", errorData);
    }
  }
};
</script>

<style scoped>
.button-wrapper {
  display: flex;
  flex-direction: row;
  align-items: space-between;
  justify-content: space-between;
  gap: 8px;
}
@media (max-width: 600px) {
  .button-wrapper {
    display: flex;
    flex-direction: row;
    align-items: space-between;
    justify-content: space-between;
    margin: 0px;
  }
}
</style>
