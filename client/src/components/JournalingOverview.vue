<template>
  <div class="page-styling">
    <div class="header">
      <h2>Journaling</h2>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, inject } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const username = ref("");
const sessionToken = ref("");

onMounted(async () => {
  sessionToken.value = localStorage.getItem("sessionToken");
  userId.value = localStorage.getItem("userId");
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }

  // //   console.log("session token", sessionToken.value);
  // //   console.log("userId.value", userId.value);

  // if (userId.value) {
  //   const userRes = await fetch(`${API_URL}/users/${userId.value}`);
  //   const userData = await userRes.json();
  //   username.value = userData.username;
  // } else {
  //   username.value = "";
  // }
});
</script>

<style scoped>
.page-styling {
  margin-left: 0px;
}
</style>
