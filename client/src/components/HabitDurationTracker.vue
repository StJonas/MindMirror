<template>
  <div class="page-styling">
    <span>Current Duration: {{ userDuration }}</span>
    <input
      type="number"
      v-model.number="duration"
      placeholder="Minutes"
      min="1"
      class="styled-input"
    />
    <button @click="saveDuration" class="button">Save</button>
  </div>
</template>

<script setup>
import { ref, defineProps, onMounted } from "vue";

const props = defineProps({
  habitId: String,
});

const userDuration = ref(0);
const duration = ref(0);

const saveDuration = async () => {
  const newDuration =
    parseFloat(userDuration.value) + parseFloat(duration.value);

  try {
    const response = await fetch(
      `http://localhost:3000/habits/${props.habitId}/update_duration`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          habit: {
            duration: newDuration,
          },
        }),
      }
    );

    if (!response.ok) {
      throw new Error("Network response was not ok");
    }

    const data = await response.json();
    console.log("Duration saved successfully:", data);
    alert("Duration saved successfully!");
    location.reload();
  } catch (error) {
    console.error("Failed to save duration:", error);
    alert("Failed to save duration.");
  }
};

const fetchHabitDetails = async () => {
  try {
    const response = await fetch(
      `http://localhost:3000/habits/${props.habitId}`
    );
    if (!response.ok) {
      throw new Error("Failed to fetch habit details");
    }
    const habit = await response.json();
    userDuration.value = parseFloat(habit.duration);
  } catch (error) {
    console.error("Error fetching habit details:", error);
  }
};

onMounted(fetchHabitDetails);
</script>
<style scoped>
.page-styling {
}
.styled-input {
  width: 100px;
  box-sizing: border-box;
  border: 2px solid #ccc;
  border-radius: 4px;
  font-size: 16px;
  color: #333;
  margin-left: 20px;
}

.button {
  border-color: black;
  margin-left: 20px;
}
</style>
