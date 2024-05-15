<template>
  <div class="checkbox-group">
    <label v-for="day in daysOfWeek" :key="day">
      {{ day }}
      <input type="checkbox" :id="day" />
    </label>
  </div>
</template>

<script>
export default {
  name: "SevenCheckboxes",
  data() {
    return {
      daysOfWeek: [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      ],
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
</style>
