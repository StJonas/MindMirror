import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "Overview",
      component: () => import("../components/Overview.vue"),
    },
    {
      path: "/habits",
      name: "HabitsOverview",
      component: () => import("../components/Habits/HabitsOverview.vue"),
    },
    {
      path: "/JournalOverview",
      name: "JournalOverview",
      component: () => import("../components/Journal/JournalOverview.vue"),
    },
    {
      path: "/AddHabit",
      name: "AddHabit",
      component: () => import("../components/Habits/AddHabit.vue"),
    },
    {
      path: "/edit/:habitId",
      name: "EditHabit",
      component: () => import("../components/Habits/EditHabit.vue"),
      props: true,
    },
    {
      path: "/SignUp",
      name: "SignUp",
      component: () => import("../components/SignUp.vue"),
    },
    {
      path: "/LogIn",
      name: "LogIn",
      component: () => import("../components/LogIn.vue"),
    },
    {
      path: "/stats",
      name: "Statistics",
      component: () => import("../components/Habits/HabitStatistics.vue"),
    },
    {
      path: "/JournalLog",
      name: "JournalLog",
      component: () => import("../components/Journal/JournalLog.vue"),
    },
    {
      path: "/AddPrompt",
      name: "AddPrompt",
      component: () => import("../components/Journal/AddPrompt.vue"),
    },
  ],
});

export default router;
