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

      <button type="submit">Sign Up</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue"; //habit
import router from "../router";

const name = ref("");
const password = ref("");
const API_URL = "http://localhost:3000";

const signUp = async () => {
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
    console.log("signup failed", res);
  }

  name.value = "";
  password.value = "";
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
