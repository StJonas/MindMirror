import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "HabitsOverview",
      component: () => import("../components/HabitsOverview.vue"),
    },
    {
      path: "/AddHabit",
      name: "AddHabit",
      component: () => import("../components/AddHabit.vue"),
    },
    {
      path: "/edit/:habitId",
      name: "EditHabit",
      component: () => import("../components/EditHabit.vue"),
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
  ],
});

export default router;
