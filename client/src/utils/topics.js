import { ref } from "vue";

export const topics = [
  { name: "Habits", route: "/HabitOverview", icon: "/mindmirror/calender.svg" },
  { name: "Journal", route: "/JournalOverview", icon: "/mindmirror/book.svg" },
  { name: "Gratitude", route: "/GratitudeOverview", icon: "/mindmirror/heart.svg" },
  { name: "Emotions", route: "/EmotionsOverview", icon: "/mindmirror/brain.svg" },
  { name: "Recharge", route: "/RechargeOverview", icon: "/mindmirror/battery.svg" },
  { name: "Freetext", route: "/FreetextOverview", icon: "/mindmirror/pen.svg" },
];

export const selectedTopics = ref([...topics.map(t => t.name)]);