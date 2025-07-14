<template>
  <div class="page-styling">
    <div class="home-container" v-if="userId">
      <router-link to="/HabitOverview" class="home-btn">Habits</router-link>
      <router-link to="/JournalOverview" class="home-btn">Journal</router-link>
      <router-link to="/GratitudeOverview" class="home-btn"
        >Gratitude</router-link
      >
      <router-link to="/EmotionsOverview" class="home-btn">Emotions</router-link>
      <router-link to="/RechargeOverview" class="home-btn">Recharge</router-link>
      <router-link to="/FreetextOverview" class="home-btn">Freetext</router-link>
    </div>
  </div>
</template>

<script setup>
import { inject } from "vue";
const userId = inject("userId");
</script>

<style scoped>
.home-container {
  display: grid;
  gap: 30px;
  justify-items: center;
  align-items: center;
  align-content: center;
  padding: 10px;
  width: 70vw;
  margin: 0 auto;
}

.home-btn {
  background: #fe712d;
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
  background: #fe8042;
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
    margin-top: auto;
    margin-bottom: auto;
    height: 65vh;
  }
  .home-btn {
    width: 100px;
    padding: 20px 0;
    font-size: 1.1rem;
  }
}
</style>
