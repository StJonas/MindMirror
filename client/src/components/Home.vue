<template>
  <div class="home-container" v-if="userId">
    <router-link to="/habits" class="home-btn">Habits</router-link>
    <router-link to="/JournalOverview" class="home-btn">Journal</router-link>
    <router-link to="/stats" class="home-btn">Gratitude</router-link>
    <router-link to="/" class="home-btn">Stress</router-link>
  </div>
</template>

<script setup>
import { inject } from "vue";
const userId = inject("userId");
</script>

<style scoped>
.home-container {
  display: grid;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  height: 80vh;
  gap: 32px;
}

.home-btn {
  background: #77dd77;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 24px 48px;
  font-size: 1.3rem;
  text-decoration: none;
  text-align: center;
  cursor: pointer;
  transition: background 0.2s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
.home-btn:hover {
  background: #45a049;
}
@media (max-width: 600px) {
  .home-container {
    display: grid;
    grid-template-columns: auto auto;
    grid-template-rows: 50px 50px;
    gap: 50px;
    justify-items: center;
    align-items: center;
    align-content: center;
    padding: 10px;
    width: 80vw;
    margin: 0 auto;
  }
  .home-btn {
    width: 100px;
    padding: 20px 0;
    font-size: 1.1rem;
  }
}
</style>
