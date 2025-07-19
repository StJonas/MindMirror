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
  width: 60vw;
  margin: 0 auto;
  background: #95b3db;
  border-radius: 18px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.home-btn {
  background: #748CAB;
  color: #000000;
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
  background: #8aa6ca;
}
@media (max-width: 600px) {
  .home-container {
    display: grid;
    grid-template-columns: auto auto;
    grid-template-rows: 50px 100px;
    gap: 40px; 
    justify-items: center;
    align-items: center;
    align-content: center;
    padding: 10px;
    margin: 0;
    height: 65vh;
    width: 100%;
  }
  .home-btn {
    width: 100px;
    padding: 20px 0;
    font-size: 1.1rem;
  }
}
</style>
