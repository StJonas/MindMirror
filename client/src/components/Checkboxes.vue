<template>
  <div class="checkbox-group">
    <label v-for="(day, index) in daysOfWeek" :key="index">
      {{ day }}
      <input
        type="checkbox"
        :checked="isChecked(day)"
        @change="updateCheckedStatus(day, $event)"
      />
    </label>
  </div>
</template>

<script>
import { ref, onMounted, computed } from "vue";

const API_URL = "http://localhost:3000/";

export default {
  name: "Checkboxes",
  props: {
    habitId: [String, Number], //String,
    userId: String,
  },
  setup(props) {
    //console.log("props: ", props);
    const daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

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
      if (props.habitId) {
        await fetchHabitHistory();
      }
    });

    async function fetchHabitHistory() {
      if (props.habitId) {
        // Check if habit prop is defined
        try {
          const response = await fetch(
            `${API_URL}/habit_histories?habit_id=${props.habitId}&user_id=${props.userId}`
          );
          if (!response.ok) {
            throw new Error("Failed to fetch habit history");
          }
          const data = await response.json();
          setCheckedDays(data);
        } catch (error) {
          console.error("Error fetching habit history:", error);
        }
      }
    }

    function setCheckedDays(habitHistories) {
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
      const userId = props.userId;
      const date = getDateForDay(day);
      const completed = checkedDays.value[habitId][day].completed;

      if (completed) {
        // Save the checked habit
        const habitHistory = {
          habit_id: habitId,
          user_id: userId,
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
            throw new Error("Network response was not ok");
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
          console.error(
            "There was a problem with the delete operation:",
            error
          );
        }
      }
    }

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

    return {
      daysOfWeek,
      checkedDays,
      saveHabit,
      updateCheckedStatus,
      isChecked,
    };
  },
};
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
</style>
