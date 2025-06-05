<template>
  <div class="header">
    <h1>{{ greeting }}</h1>
    <div class="auth-buttons">
      <router-link to="/login" v-if="!userId">
        <button>
          <img
            src="/login.svg"
            alt="Login"
            class="button"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <router-link to="/signup" v-if="!userId">
        <button>
          <img
            src="/signup.svg"
            alt="Login"
            class="button"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <div v-if="userId">
        <button @click="logout">
          <img
            src="/logout.svg"
            alt="Logout"
            class="button"
            style="width: 24px; height: 24px"
          />
        </button>
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
  justify-content: flex-start;
  align-items: center;
  padding: 10px;
}

.auth-buttons {
  position: absolute;
  top: 75px;
  right: 50px;
  display: flex;
  gap: 16px;
  align-items: center;
}
</style>
