import { ref } from "vue";

export const topics = [
  { name: "Habits", route: "/HabitOverview", icon: "/calender.svg" },
  { name: "Journal", route: "/JournalOverview", icon: "/book.svg" },
  { name: "Gratitude", route: "/GratitudeOverview", icon: "/heart.svg" },
  { name: "Emotions", route: "/EmotionsOverview", icon: "/brain.svg" },
  { name: "Recharge", route: "/RechargeOverview", icon: "/battery.svg" },
  { name: "Freetext", route: "/FreetextOverview", icon: "/pen.svg" },
];

export const selectedTopics = ref([...topics.map(t => t.name)]);