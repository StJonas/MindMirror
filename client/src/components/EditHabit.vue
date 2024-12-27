<template>
  <div class="form-container">
    <div class="header-row">
      <button @click="goBack">&lt;</button>
      <h2>Edit Habit: {{ oldName }}</h2>
    </div>

    <input type="text" v-model="name" placeholder="name" class="name-input" />
    <input
      type="number"
      v-model="frequency"
      placeholder="frequency"
      class="body-input"
    />

    <button @click="updateHabit(habit_id)">Save</button>
    <button @click="deleteHabit(habit_id)">Delete</button>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";
import { useRoute } from "vue-router";
import router from "../router";

const habits = ref([]);
const name = ref("");
const oldName = ref("");
const frequency = ref("");
const habit_id = ref(0);
const isEditing = ref(false);
const API_URL = inject("API_URL");
const emit = defineEmits(["navigateBackToHabit"]);

const route = useRoute();

const props = defineProps({
  habitId: Number,
});

onMounted(async () => {
  if (props.habitId) {
    const res = await fetch(`${API_URL}/habits/${props.habitId}`);
    const fetchedHabit = await res.json();
    if (fetchedHabit) {
      name.value = fetchedHabit.name;
      frequency.value = fetchedHabit.frequency;
      habit_id.value = fetchedHabit.id;
      oldName.value = fetchedHabit.name;
    }
  }
});

const updateHabit = async () => {
  const res = await fetch(`${API_URL}/habits/${habit_id.value}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: name.value,
      frequency: frequency.value,
      id: habit_id.value,
    }),
  });

  const data = await res.json();

  const index = habits.value.findIndex((habit) => habit.id === data.id);
  habits.value[index] = data;

  name.value = "";
  frequency.value = "";
  habit_id.value = 0;
  isEditing.value = false;

  router.push("/");
};

const deleteHabit = async (id) => {
  if (confirm("Are you sure you want to delete this habit?")) {
    //deleting all habit histories associated with the habit
    await fetch(`${API_URL}/habit_histories/habit/${id}`, {
      method: "DELETE",
    });

    //deleting habit itself
    await fetch(`${API_URL}/habits/${id}`, {
      method: "DELETE",
    });

    habits.value = habits.value.filter((habit) => habit.id !== id);
  }
  router.push("/");
};

const goBack = () => {
  emit("navigateBackToHabit");
};
</script>

<style scoped>
.form-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-left: 30px;
}

.header-row {
  display: flex;
  align-items: center;
  gap: 20px;
}

.name-input {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}

.body-input {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}

.form-container button {
  flex-shrink: 0;
  margin-left: 10px;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
