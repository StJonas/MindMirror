<template>
  <div class="checkbox-group">
    <label v-for="(day, index) in daysOfWeek" :key="index">
      {{ day }}
      <input type="checkbox" v-model="checkedDays[day]" />
    </label>
    <button @click="saveHabits">Save</button>
  </div>
</template>

<script>
import { reactive, watch, onMounted } from "vue";

const API_URL = "http://localhost:3000/";

export default {
  name: "Checkboxes",
  props: {
    habit: Object,
    userId: String,
  },
  setup(props) {
    const daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    const checkedDays = reactive({
      Monday: false,
      Tuesday: false,
      Wednesday: false,
      Thursday: false,
      Friday: false,
      Saturday: false,
      Sunday: false,
    });

    const resetCheckedDays = () => {
      Object.keys(checkedDays).forEach((day) => {
        checkedDays[day] = false;
      });
    };

    const fetchHabitHistory = async () => {
      try {
        const response = await fetch(
          `${API_URL}/habit_histories?habit_id=${props.habit.id}&user_id=${props.userId}`
        );
        if (!response.ok) {
          throw new Error("Failed to fetch habit history");
        }
        const data = await response.json();
        setCheckedDays(data);
      } catch (error) {
        console.error("Error fetching habit history:", error);
      }
    };

    const setCheckedDays = (habitHistories) => {
      habitHistories.forEach((history) => {
        const day = getDayFromDate(new Date(history.date));
        if (day) {
          checkedDays[day] = history.completed;
        }
      });
    };

    const saveHabits = async () => {
      const habitHistory = [];
      const habitId = props.habit.id;
      const userId = props.userId;

      Object.keys(checkedDays).forEach((day) => {
        const date = getDateForDay(day);
        habitHistory.push({
          habit_id: habitId,
          user_id: userId,
          date: date,
          completed: checkedDays[day],
        });
      });

      try {
        const response = await fetch(`${API_URL}/habit_histories`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(habitHistory),
        });

        if (!response.ok) {
          throw new Error("Network response was not ok");
        }

        const data = await response.json();
        console.log("Save successful", data);
      } catch (error) {
        console.error("There was a problem with the save operation:", error);
      }
    };

    const getDateForDay = (day) => {
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
      return resultDate.toISOString().split("T")[0];
    };

    const getDayFromDate = (date) => {
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
    };

    watch(
      () => props.habit,
      async () => {
        resetCheckedDays();
        await fetchHabitHistory();
      },
      { immediate: true }
    );

    onMounted(async () => {
      await fetchHabitHistory();
    });

    return {
      daysOfWeek,
      checkedDays,
      saveHabits,
      fetchHabitHistory,
      setCheckedDays,
      getDateForDay,
      getDayFromDate,
    };
  },
};
</script>

<style scoped>
.checkbox-group {
  display: flex;
  flex-wrap: wrap;
  margin: 0;
  padding: 0;
}

.checkbox-group label {
  margin-right: 10px;
}

.checkbox-group input[type="checkbox"] {
  margin-right: 5px;
}

button {
  margin-top: 10px;
}
</style>
