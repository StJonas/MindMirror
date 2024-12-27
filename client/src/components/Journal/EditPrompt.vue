<template>
  <div class="edit-prompt">
    <div class="form-container">
      <input
        type="text"
        v-model="promptTitle"
        placeholder="Prompt Title"
        class="name-input"
      />
      <button @click="savePrompt" class="save-button">
        <img
          src="/public/save.svg"
          alt="Save"
          class="icon"
          style="width: 24px; height: 24px"
        />
      </button>
      <button @click="deletePrompt" class="delete-button">
        <img
          src="/public/delete.svg"
          alt="Delete"
          class="icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, defineProps, inject } from "vue";

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
    console.log("Prompt updated successfully");
    location.reload();
  } else {
    const errorData = await res.json();
    console.error("Error updating prompt:", errorData);
  }
};

const deletePrompt = async () => {
  if (confirm("Are you sure you want to delete this habit?")) {
    const res = await fetch(`${API_URL}/prompts/${props.prompt.id}`, {
      method: "DELETE",
    });

    if (res.ok) {
      console.log("Prompt deleted successfully");
      location.reload();
    } else {
      const errorData = await res.json();
      console.error("Error deleting prompt:", errorData);
    }
  }
};
</script>

<style scoped>
.edit-prompt {
  padding: 20px;
}

.header-row {
  display: flex;
  align-items: center;
  gap: 20px;
}

.form-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-top: 20px;
}

.name-input {
  width: 500px;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}

.save-button {
  padding: 10px 20px;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.save-button:hover {
  background-color: #45a049;
}
.delete-button {
  background-color: red;
}
</style>
