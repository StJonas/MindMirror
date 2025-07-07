<template>
  <div class="page-styling">
    <div class="header-row">
      <router-link to="/HabitOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Edit Habit: {{ oldName }}</h2>
      <button @click="deleteHabit(habit_id)" class="delete-button">
        <img
          src="/delete.svg"
          alt="Delete"
          class="white-icon"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
    <div class="section-box"> 
      <input
        type="text"
        v-model="name"
        placeholder="name"
        class="general-input"
      />
      <input
        rows="4"
        v-model="description"
        placeholder="description"
        class="general-input"
      />

      <button @click="updateHabit(habit_id)" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";
import { useRoute } from "vue-router";
import router from "../../router";

const habits = ref([]);
const name = ref("");
const oldName = ref("");
const frequency = ref("");
const description = ref("");
const habit_id = ref(0);
const isEditing = ref(false);
const API_URL = inject("API_URL");

const props = defineProps({
  habitId: String,
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
      description.value = fetchedHabit.description;
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
      frequency: 0,
      id: habit_id.value,
      description: description.value,
    }),
  });

  const data = await res.json();

  const index = habits.value.findIndex((habit) => habit.id === data.id);
  habits.value[index] = data;

  router.push("/HabitOverview").then(() => {
    window.location.reload();
  });
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
  router.push("/HabitOverview");
};
</script>

<style scoped></style>
