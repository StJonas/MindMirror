<template>
  <div class="input">
    <h1>Login</h1>
    <form @submit.prevent="login">
      <label for="username">Username:</label>
      <input
        id="username"
        v-model="username"
        type="text"
        required
        class="name-input"
      />

      <label for="password">Password:</label>
      <input
        id="password"
        v-model="password"
        type="password"
        required
        class="name-input"
      />

      <button type="submit">Login</button>
      <router-link to="/">
        <button type="button">Go Back</button>
      </router-link>
    </form>
  </div>
</template>

<script setup>
import { ref, inject } from "vue";
import router from "../router";
import axios from "axios";

const username = ref("");
const password = ref("");
const API_URL = inject("API_URL");
const user = inject("user");

const login = async () => {
  const res = await fetch(`${API_URL}/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      username: username.value,
      password: password.value,
    }),
  });

  if (res.ok) {
    const data = await res.json();
    user.data = data.id;
    //console.log("userId", data.user.id);

    localStorage.setItem("sessionToken", data.token);
    localStorage.setItem("userId", data.user.id);
    router.push("/");
  } else {
    console.error("Login failed");
    console.log("name ", username.value);
    console.log("pw ", password.value);
  }

  username.value = "";
  password.value = "";
};
</script>

<style>
.input {
  resize: vertical;
}

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

.input body-input {
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
.input button {
  border-color: black;
  text-emphasis-color: black;
  text-decoration-color: black;
  margin-left: 10px;
}
</style>
