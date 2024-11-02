<template>
  <div class="page-styling">
    <HeaderComponent :userId="userId" :username="username" @logout="logout" />
    <JournalNavigationButtons
      :currentPage="currentPage"
      @update:currentPage="currentPage = $event"
    />

    <div class="content">
      <div v-if="currentPage === 'habits'">
        <HabitsOverview />
      </div>
      <div v-else-if="currentPage === 'journaling'">
        <JournalingOverview />
      </div>
    </div>
  </div>
</template>

<script setup>
import HabitsOverview from "./HabitsOverview.vue";
import JournalingOverview from "./JournalingOverview.vue";
import HeaderComponent from "./HeaderComponent.vue";
import JournalNavigationButtons from "./JournalNavigationButtons.vue";
import { ref, onMounted } from "vue";

const habits = ref([]);
const API_URL = "http://localhost:3000/";
const userId = ref("");
const username = ref("");
const sessionToken = ref("");
const currentPage = ref("habits");

onMounted(async () => {
  sessionToken.value = localStorage.getItem("sessionToken");
  userId.value = localStorage.getItem("userId");
  if (userId.value != null) {
    const res = await fetch(`${API_URL}/users/${userId.value}/habits`);
    habits.value = await res.json();
  }

  //   console.log("session token", sessionToken.value);
  //   console.log("userId.value", userId.value);

  if (userId.value) {
    const userRes = await fetch(`${API_URL}/users/${userId.value}`);
    const userData = await userRes.json();
    username.value = userData.username;
  } else {
    username.value = "";
  }
});

const logout = () => {
  userId.value = "";
  username.value = "";
  sessionToken.value = "";

  // Clear user-related data from localStorage
  localStorage.removeItem("userId");
  localStorage.removeItem("sessionToken");
  location.reload();
};
</script>

<style scoped>
.page-styling {
  margin-left: 140px;
  min-width: 100vh;
}

.content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.content > div {
  flex: 1;
}
</style>
