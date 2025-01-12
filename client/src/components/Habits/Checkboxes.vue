<template>
  <div class="checkbox-group">
    <label
      v-for="(day, index) in daysOfWeek"
      :key="index"
      class="custom-checkbox"
      :class="{ checked: isChecked(day), disabled: !props.isCurrentWeek }"
    >
      {{ day }}
      <input
        type="checkbox"
        :checked="isChecked(day)"
        @change="updateCheckedStatus(day, $event)"
        :disabled="!props.isCurrentWeek"
      />
    </label>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch, inject } from "vue";

const API_URL = inject("API_URL");
const userId = inject("userId");

const props = defineProps({
  habitId: Number,
  currentDay: Date,
  isCurrentWeek: Boolean,
});

const isChecked = computed(() => {
  return (day) => {
    return checkedDays.value[props.habitId] &&
      checkedDays.value[props.habitId][day]
      ? checkedDays.value[props.habitId][day].completed
      : false;
  };
});

const updateCheckedStatus = (day, event) => {
  if (!checkedDays.value[props.habitId]) {
    checkedDays.value[props.habitId] = {};
  }

  if (!checkedDays.value[props.habitId][day]) {
    checkedDays.value[props.habitId][day] = { completed: false };
  }

  checkedDays.value[props.habitId][day].completed = event.target.checked;

  saveHabit(day);
};

const checkedDays = ref({});

onMounted(async () => {
  if (props.habitId && userId) {
    await fetchHabitHistoryForWeek(props.currentDay);
  }
});

const clearCheckedDays = () => {
  checkedDays.value = {};
};

const fetchHabitHistoryForWeek = async (weekStartDate) => {
  if (userId.value) {
    const url = `${API_URL}/users/${userId.value}/habits/${
      props.habitId
    }/habit_histories/week?currentDay=${weekStartDate.toISOString()}`;

    try {
      const res = await fetch(url);
      if (!res.ok) {
        const errorData = await res.json();
        console.error("Error fetching habit history:", errorData);
        return;
      }
      const data = await res.json();
      setCheckedDays(data);
    } catch (error) {
      console.error("There was a problem with the fetch operation:", error);
    }
  }
};

function setCheckedDays(habitHistories) {
  if (habitHistories.length === 0) {
    return;
  }

  habitHistories.forEach((history) => {
    const habitId = history.habit_id;
    const day = getDayFromDate(new Date(history.date));
    if (day) {
      if (!checkedDays.value[habitId]) {
        checkedDays.value[habitId] = {};
      }
      checkedDays.value[habitId][day] = history;
    }
  });
}

async function saveHabit(day) {
  const habitId = props.habitId;
  const date = getDateForDay(day);
  const completed = checkedDays.value[habitId][day].completed;

  if (completed) {
    // Save the checked habit
    const habitHistory = {
      habit_id: habitId,
      user_id: userId.value,
      date: date,
      completed: completed,
    };

    try {
      const response = await fetch(`${API_URL}/habit_histories`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify([habitHistory]),
      });

      if (!response.ok) {
        throw new Error(
          "Network response was not ok - userId",
          userId,
          " habitId: ",
          habitId
        );
      }

      const data = await response.json();
      checkedDays.value[habitId][day] = data[0];
      console.log("Save successful", data);
    } catch (error) {
      console.error("There was a problem with the save operation:", error);
    }
  } else if (
    checkedDays.value[habitId][day] &&
    checkedDays.value[habitId][day].id
  ) {
    // Delete the unchecked habit
    try {
      const response = await fetch(
        `${API_URL}/habit_histories/${checkedDays.value[habitId][day].id}`,
        { method: "DELETE" }
      );

      if (!response.ok) {
        throw new Error("Network response was not ok");
      }

      console.log("Delete successful");
      checkedDays.value[habitId][day] = { completed: false };
    } catch (error) {
      console.error("There was a problem with the delete operation:", error);
    }
  }
}

const daysOfWeek = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

function getDateForDay(day) {
  const today = new Date();
  const currentDay = today.getDay(); // 0 (Sunday) to 6 (Saturday)
  const dayMap = {
    Sunday: 0,
    Monday: 1,
    Tuesday: 2,
    Wednesday: 3,
    Thursday: 4,
    Friday: 5,
    Saturday: 6,
  };
  const diff = (dayMap[day] + 7 - currentDay) % 7;
  const resultDate = new Date(today);
  resultDate.setDate(today.getDate() + diff);
  return resultDate.toISOString().split("T")[0]; // format as YYYY-MM-DD
}

function getDayFromDate(date) {
  const dayMap = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  return dayMap[date.getDay()];
}

watch(
  () => props.currentDay,
  async (newWeekStart) => {
    clearCheckedDays();
    await fetchHabitHistoryForWeek(newWeekStart);
  },
  { immediate: true }
);

watch(
  () => userId,
  async () => {
    await fetchHabitHistoryForWeek(props.currentDay);
  },
  { immediate: true }
);
</script>

<style scoped>
.checkbox-group {
  display: flex;

  margin: 0;
  padding: 0;
}

.checkbox-group label {
  margin-right: 10px;
}

.checkbox-group input[type="checkbox"] {
  margin-right: 5px;
}

.custom-checkbox {
  position: relative;
  display: inline-block;
  padding: 10px 20px;
  border: 0px solid #ccc;
  border-radius: 4px;
  background-color: #c9c8c8;
  cursor: pointer;
  user-select: none;
  font-size: 14px;
  font-weight: 500;
  transition: background-color 0.3s, border-color 0.3s;
  color: black;
}

.custom-checkbox input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.custom-checkbox.checked {
  background-color: darkgreen;
  color: white;
  border: 0px solid #ccc;
}

.custom-checkbox.disabled {
  background-color: #e0e0e0;
  cursor: not-allowed;
}

.custom-checkbox.disabled.checked {
  background-color: #2e7d32;
  cursor: not-allowed;
}

.custom-checkbox.disabled.checked:hover {
  background-color: #2e7d32;
}

.custom-checkbox:hover {
  background-color: #e0e0e0;
}

.custom-checkbox.checked:hover {
  background-color: #45a049;
}
</style>
