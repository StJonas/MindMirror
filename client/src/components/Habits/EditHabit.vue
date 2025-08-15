<template>
  <div class="page-styling">
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="header-row">
      <router-link to="/HabitOverview">
        <button type="button">&lt;</button>
      </router-link>
      <h2>Edit Habit: {{ oldName }}</h2>
      <button @click="deleteHabit(habit_id)" class="delete-button">
        <img src="/delete.svg" alt="Delete" class="white-icon" style="width: 24px; height: 24px" />
      </button>
    </div>
    <div class="section-box">
      <input type="text" v-model="name" placeholder="name" class="general-input" />
      <input rows="4" v-model="description" placeholder="description" class="general-input" />

      <button @click="updateHabit(habit_id)" class="save-button">
        <img src="/save.svg" alt="Save" class="white-icon" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";
import { fetchWithAuth } from '../../utils/apiHelpers';
import router from "../../router";
import Toast from "../Toast.vue";
import { useToast } from "../../utils/useToast.js";
import { postLog } from '../../utils/loggerHelper';

const habits = ref([]);
const userId = inject("userId");
const name = ref("");
const oldName = ref("");
const frequency = ref("");
const description = ref("");
const habit_id = ref(0);
const isEditing = ref(false);
const API_URL = inject("API_URL");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const props = defineProps({
  habitId: String,
});

onMounted(async () => {
  if (props.habitId) {
    const data = await fetchWithAuth(`${API_URL}/habits/${props.habitId}`);
    const fetchedHabit = await data;
    if (fetchedHabit) {
      name.value = fetchedHabit.name;
      frequency.value = fetchedHabit.frequency;
      habit_id.value = fetchedHabit.id;
      oldName.value = fetchedHabit.name;
      description.value = fetchedHabit.description;
    }
  }
  postLog({ userId: userId.value, page: "EditHabit" });
});

const updateHabit = async () => {
  try {
    const res = await fetchWithAuth(`${API_URL}/habits/${habit_id.value}`,
      {
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
      },
      true
    );

    if (res.ok) {
      const data = await res.json();
      const index = habits.value.findIndex((habit) => habit.id === data.id);
      habits.value[index] = data;

      showToast("Habit updated successfully!", "success");
      postLog({ event: "habit_updated", userId: userId.value, page: "EditHabit", data: { habitName: name.value } });

      setTimeout(() => {
        router.push("/HabitOverview").then(() => {
          window.location.reload();
        });
      }, 500);
    } else {
      showToast("Failed to update habit!", "error");
      const errorData = await res.json();
      console.error("Error updating habit:", errorData);
    }
  } catch (error) {
    showToast("Failed to update habit!", "error");
    console.error(error);
  }
};

const deleteHabit = async (id) => {
  if (confirm("Are you sure you want to delete this habit?")) {
    try {
      const habitRes = await fetchWithAuth(`${API_URL}/habits/${id}`, {
        method: "DELETE",
      },
        true
      );

      if (habitRes.ok) {
        habits.value = habits.value.filter((habit) => habit.id !== id);
        showToast("Habit deleted successfully!", "success");
        postLog({ event: "habit_deleted", userId: userId.value, page: "EditHabit", data: { habitName: name.value } });

        setTimeout(() => {
          router.push("/HabitOverview").then(() => {
            window.location.reload();
          });
        }, 500);
      } else {
        showToast("Failed to delete habit!", "error");
        console.error("Error deleting habit:", await habitRes.text());
      }
    } catch (error) {
      showToast("Failed to delete habit!", "error");
      console.error(error);
    }
  }
};
</script>

<style scoped></style>
