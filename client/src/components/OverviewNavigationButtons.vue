<template>
  <div class="button">
    <router-link
      to="/habits"
      class="nav-link"
      :class="{
        active:
          $route.path.startsWith('/habits') || $route.path === '/statistics',
      }"
    >
      Habits
    </router-link>
    <router-link
      to="/JournalOverview"
      class="nav-link"
      :class="{
        active:
          $route.path.startsWith('/JournalOverview') ||
          $route.path === '/journalLog' ||
          $route.path === '/addPrompt',
      }"
    >
      Journal
    </router-link>
    <router-link to="/" class="nav-link">+</router-link>
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
