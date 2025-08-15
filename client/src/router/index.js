import { createRouter, createWebHistory } from "vue-router";
import { selectedTopics } from '../utils/topics.js';

const router = createRouter({
  history: createWebHistory('/mindmirror/'),
  //history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "Home",
      component: () => import("../components/Home.vue"),
    },
    {
      path: "/HabitOverview",
      name: "HabitOverview",
      component: () => import("../components/Habits/HabitOverview.vue"),
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
      path: "/editHabit/:habitId",
      name: "EditHabit",
      component: () => import("../components/Habits/EditHabit.vue"),
      props: true,
    },
    {
      path: "/HabitLog",
      name: "HabitLog",
      component: () => import("../components/Habits/HabitLog.vue"),
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
    {
      path: "/GratitudeOverview",
      name: "GratitudeOverview",
      component: () => import("../components/Gratitude/GratitudeOverview.vue"),
    },
    {
      path: "/GratitudeLog",
      name: "GratitudeLog",
      component: () => import("../components/Gratitude/GratitudeLog.vue"),
    },
    {
      path: "/FreetextOverview",
      name: "FreetextOverview",
      component: () => import("../components/Freetext/FreetextOverview.vue"),
    },
    {
      path: "/FreetextLog",
      name: "FreetextLog",
      component: () => import("../components/Freetext/FreetextLog.vue"),
    },
    {
      path: "/EmotionsOverview",
      name: "EmotionsOverview",
      component: () => import("../components/Emotions/EmotionsOverview.vue"),
    },
    {
      path: "/EmotionsLog",
      name: "EmotionsLog",
      component: () => import("../components/Emotions/EmotionsLog.vue"),
    },
    {
      path: "/RechargeOverview",
      name: "RechargeOverview",
      component: () => import("../components/Recharge/RechargeOverview.vue"),
    },
    {
      path: "/RechargeLog",
      name: "RechargeLog",
      component: () => import("../components/Recharge/RechargeLog.vue"),
    },
    {
      path: "/Statistics",
      name: "Statistics",
      component: () => import("../components/Statistics.vue"),
    }
  ],
});

router.beforeEach((to, from, next) => {
  const routeToTopic = {
    HabitOverview: 'Habits',
    JournalOverview: 'Journal',
    GratitudeOverview: 'Gratitude',
    EmotionsOverview: 'Emotions',
    RechargeOverview: 'Recharge',
    FreetextOverview: 'Freetext',
  };

  const topicName = routeToTopic[to.name];

  if (topicName && !selectedTopics.value.includes(topicName)) {
    next({ path: '/' });
  } else {
    next();
  }
});

export default router;
