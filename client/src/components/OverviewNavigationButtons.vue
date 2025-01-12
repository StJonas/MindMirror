<template>
  <div class="navigation-buttons">
    <button
      type="button"
      @click="changePage('habits')"
      :class="{
        active:
          currentPage === 'habits' ||
          currentPage === 'editHabit' ||
          currentPage === 'addHabit' ||
          currentPage === 'statistics',
      }"
    >
      Habits
    </button>
    <button
      type="button"
      @click="changePage('journaling')"
      :class="{
        active:
          currentPage === 'journaling' ||
          currentPage === 'journalLog' ||
          currentPage === 'addPrompt',
      }"
    >
      Journal
    </button>
    <button>+</button>
  </div>
</template>

<script>
export default {
  props: ["currentPage"],
  methods: {
    changePage(page) {
      this.$emit("update:currentPage", page);
    },
  },
};
</script>

<style scoped>
.navigation-buttons {
  margin-left: 20px;
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}
.navigation-buttons button {
  background-color: lightblue;
  color: white;
  border: none;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  cursor: pointer;
  border-radius: 4px;
  outline: none;
  color: black;
}
.navigation-buttons button.active {
  background-color: orange;
}
.navigation-buttons button:hover:not(.active) {
  background-color: orange;
}
</style>
