<template>
  <div>
    <Toast ref="toastRef" :message="toastMessage" :type="toastType" />
    <div class="side-by-side">
      <router-link to="/">
        <button type="button" class="back-btn">&lt;</button>
      </router-link>
      <h2>Sign Up</h2>
    </div>

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
    </form>
  </div>
</template>

<script setup>
import { ref, inject } from "vue";
import router from "../router";
import Toast from "./Toast.vue";
import { useToast } from "../utils/useToast.js";

const name = ref("");
const password = ref("");
const password_confirmation = ref("");
const API_URL = inject("API_URL");
const toastRef = ref(null);
const { showToast, toastMessage, toastType } = useToast(toastRef);

const signUp = async () => {
  if (password.value !== password_confirmation.value) {
    password.value = "";
    password_confirmation.value = "";
    showToast("Passwords do not match!", "error");
    return;
  }

  const res = await fetch(`${API_URL}/users`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      user: {
        username: name.value,
        password: password.value,
      },
    }),
  });

  if (!res.ok) {
    showToast("Signup failed!", "error");
  } else {
    name.value = "";
    password.value = "";
    password_confirmation.value = "";
    showToast("Signup successful!", "success");
    setTimeout(() => {
      router.push("/login").then(() => {
        window.location.reload();
      });
    }, 500);
  }
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
