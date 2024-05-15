<template>
  <div>
    <h1>Edit Habit: {{ oldName }}</h1>

    <input type="text" v-model="name" placeholder="name" class="name-input" />
    <input
      type="number"
      v-model="frequency"
      placeholder="frequency"
      class="body-input"
    />

    <button @click="updateHabit(habit_id)">Save</button>
    <button @click="deleteHabit(habit_id)">Delete</button>

    <button type="button">
      <router-link to="/">Go Back</router-link>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue"; //habit
import { useRoute } from "vue-router";
import router from "../router";

const habits = ref([]);
const name = ref("");
const oldName = ref("");
const frequency = ref("");
const habit_id = ref(0);
const isEditing = ref(false);
const API_URL = "http://localhost:3000/habits";

const route = useRoute();

onMounted(async () => {
  const habitId = parseInt(route.params.habitId);

  if (habitId) {
    const res = await fetch(`${API_URL}/${habitId}`);
    const fetchedHabit = await res.json();
    if (fetchedHabit) {
      // Check if habit exists
      name.value = fetchedHabit.name;
      frequency.value = fetchedHabit.frequency;
      habit_id.value = fetchedHabit.id;
      oldName.value = fetchedHabit.name;
    }
  }
});

const updateHabit = async () => {
  const res = await fetch(`${API_URL}/${habit_id.value}`, {
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
    await fetch(`${API_URL}/${id}`, {
      method: "DELETE",
    });
    habits.value = habits.value.filter((habit) => habit.id !== id);
  }
  router.push("/");
};
</script>

<style scoped>
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
</style>
