<template>
  <div>
    <h1>Sign Up</h1>
    <form @submit.prevent="signUp">
      <label for="name">Username:</label>
      <input id="name" v-model="name" type="text" required class="name-input" />

      <label for="password">Password:</label>
      <input
        id="password"
        v-model="password"
        type="password"
        required
        class="name-input"
      />
      <label for="password">Password Confimation:</label>
      <input
        id="password_confirmation"
        v-model="password_confirmation"
        type="password"
        required
        class="name-input"
      />

      <button type="submit">Sign Up</button>
      <button type="button">
        <router-link to="/">Go Back</router-link>
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, inject } from "vue"; //habit
import router from "../router";

const name = ref("");
const password = ref("");
const password_confirmation = ref("");
//const API_URL = inject("API_URL");
const API_URL = "http://localhost:3000/";

const signUp = async () => {
  if (password.value !== password_confirmation.value) {
    password.value = "";
    password_confirmation.value = "";
    alert("Passwords do not match!");
    return;
  }

  const res = await fetch(`${API_URL}/users`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      username: name.value,
      password: password.value,
    }),
  });

  if (!res.ok) {
    const data = await res.json();
    console.log("error data:", data);
  }

  name.value = "";
  password.value = "";
  password_confirmation.value = "";
  router.push("/");
};
</script>

<style>
.name-input {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}

.body-input {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #ccc;
  background-color: #f8f8f8;
  color: #111;
  border-radius: 4px;
  resize: vertical;
}
</style>
