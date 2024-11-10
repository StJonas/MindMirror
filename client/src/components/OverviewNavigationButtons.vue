<template>
  <div class="navigation-buttons">
    <button
      type="button"
      @click="changePage('habits')"
      :class="{ active: currentPage === 'habits' }"
    >
      Habits
    </button>
    <button
      type="button"
      @click="changePage('journaling')"
      :class="{ active: currentPage === 'journaling' }"
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
}
.navigation-buttons button.active {
  background-color: #45a049;
}
</style>
