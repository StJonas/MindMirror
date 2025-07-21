<template class="page-styling">
  <div class="header">
    <router-link to="/">
      <button class="circle-btn">
        <img src="/circle.svg" alt="Home" class="circle-icon" />
        <span class="home-text">MindMirror</span>
      </button>
    </router-link>
    <div class="auth-buttons">
      <router-link
        to="/login"
        v-if="!userId && route.path !== '/login' && route.path !== '/signup'"
      >
        <button>
          <img
            src="/login.svg"
            alt="Login"
            class="button"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
      <router-link
        to="/signup"
        v-if="!userId && route.path !== '/login' && route.path !== '/signup'"
      >
        <button>
          <img
            src="/signup.svg"
            alt="Login"
            class="button"
            style="width: 24px; height: 24px"
          />
        </button>
      </router-link>
    </div>
    <div v-if="userId" class="auth-logout">
      <button @click="logout" style="background: #ff6f6f">
        <img
          src="/logout.svg"
          alt="Logout"
          class="button"
          style="width: 24px; height: 24px"
        />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, inject } from "vue";
import { useRoute } from "vue-router";

const emit = defineEmits(["logout"]);
const username = inject("username", "");
const userId = inject("userId");
const greeting = ref("");
const route = useRoute();

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
.auth-buttons {
  position: absolute;
  top: 75px;
  right: 50px;
  display: flex;
  gap: 16px;
  align-items: center;
}

.circle-btn {
  background: none;
  border: none;
  cursor: pointer;
  margin: 0;
}

.circle-icon {
  margin-right: 8px;
  filter: invert(1) brightness(1000%);
  width: 3rem;
  height: 3rem;
}

.home-text {
  font-size: 2.5rem;
  color: white;
  font-weight: 500;
}

.auth-logout {
  position: absolute;
  top: 20px;
  right: 150px;
}

@media (max-width: 700px) {
  .circle-btn {
    margin-left: 4rem;
  }
  .circle-icon {
    width: 2rem;
    height: 2rem;
  }
  .home-text {
    font-size: 2rem;
    color: white;
    font-weight: 500;
    margin-bottom: 0.25rem;
  }
  .auth-buttons {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    flex-direction: row;
    gap: 24px;
    z-index: 100;
    background: none;
  }
  .auth-logout {
    position: absolute;
    top: 20px;
    right: 20px;
  }
}
</style>
