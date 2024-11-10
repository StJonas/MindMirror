<template>
  <div class="header">
    <h1>{{ greeting }}</h1>
    <div class="auth-buttons">
      <router-link to="/login" v-if="!userId">
        <button type="button">Login</button>
      </router-link>
      <router-link to="/signup" v-if="!userId">
        <button type="button">Signup</button>
      </router-link>
      <div class="logout">
        <button @click="logout" v-if="userId">Logout</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, inject } from "vue";

const emit = defineEmits(["logout"]);
const username = inject("username", "");
const userId = inject("userId");
const greeting = ref("");

const updateGreeting = () => {
  const currentHour = new Date().getHours();
  if (currentHour < 12) {
    greeting.value = "Good Morning " + username.value;
  } else if (currentHour < 18) {
    greeting.value = "Good Afternoon " + username.value;
  } else {
    greeting.value = "Good Evening " + username.value;
  }
};

watch(username, updateGreeting, { immediate: true });

const logout = () => {
  emit("logout");
};
</script>
<style scoped>
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background-color: #f8f9fa;
}
.auth-buttons {
  display: flex;
  align-items: center;
  position: absolute;
  top: 85px;
  right: 250px;
}
.auth-buttons button {
  margin-left: 10px;
  font-size: 16px;
  cursor: pointer;
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
}
</style>
