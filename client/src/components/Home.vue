<template>
  <div class="page-styling">
    <div class="home-container" v-if="userId">
      <router-link to="/HabitOverview" class="home-btn">
        <img src="/calender.svg" alt="icon" class="home-icon" />
        Habits
      </router-link>
      <router-link to="/JournalOverview" class="home-btn">
        <img src="/book.svg" alt="icon" class="home-icon" />
        Journal
      </router-link>
      <router-link to="/GratitudeOverview" class="home-btn">
        <img src="/heart.svg" alt="icon" class="home-icon" />
        Gratitude
      </router-link>
      <router-link to="/EmotionsOverview" class="home-btn">
        <img src="/brain.svg" alt="icon" class="home-icon" />
        Emotions
      </router-link>
      <router-link to="/RechargeOverview" class="home-btn">
        <img src="/battery.svg" alt="icon" class="home-icon" />
        Recharge
      </router-link>
      <router-link to="/FreetextOverview" class="home-btn">
        <img src="/pen.svg" alt="icon" class="home-icon" />
        Freetext
      </router-link>
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
  grid-template-columns: 1fr 1fr;
  gap: 18px;
  justify-items: center;
  align-items: center;
  padding: 24px 0;
  width: 420px;
  margin: 0 auto;
  background: #95b3db;
  border-radius: 18px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.home-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #748CAB;
  color: #000000;
  border: none;
  border-radius: 12px;
  padding: 32px 0;
  width: 90%;
  height: 100px;
  font-size: 1.5rem;
  text-decoration: none;
  text-align: center;
  cursor: pointer;
  transition: background 0.2s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin: 0;
}
.home-btn:hover {
  background: #8aa6ca;
}
.home-icon {
  width: 32px;
  height: 32px;
  margin-bottom: 8px;
}

@media (max-width: 600px) {
  .home-container {
    width: 80vw;
    max-width: 400px;
    padding: 12px 0;
    gap: 12px;
    grid-template-columns: 1fr 1fr;
    margin-top: 100px;
  }
  .home-btn {
    font-size: 1.2rem;
    padding: 24px 0;
    width: 96%;
  }
}
</style>
