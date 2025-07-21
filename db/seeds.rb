# Clear existing prompts
Prompt.where(predefined: true).destroy_all

# Add predefined prompts
predefined_prompts = [
  { title: "What are you proud of yourself for today?", weekly: false, predefined: true },
  { title: "What did I accomplish today?", weekly: false, predefined: true },
  { title: "What did I learn today?", weekly: false, predefined: true },
  { title: "What was my biggest challange this week?", weekly: true, predefined: true },
  { title: "What was my biggest learning this week?", weekly: true, predefined: true },
  { title: "What was my favorite moment of this week?", weekly: true, predefined: true },
  { title: "What did you learn today?", weekly: false, predefined: true },
  { title: "What strengths did you use today?", weekly: false, predefined: true },
  { title: "What challenges did you overcome?", weekly: false, predefined: true },
  { title: "What are the most valuable lessons you've learned from past experiences?", weekly: true, predefined: true },
  { title: "What were some of the most interesting discoveries you made while working on this project?", weekly: true, predefined: true },
  { title: "What are some things that challenged your thinking, or that you disagree with?", weekly: true, predefined: true },
  { title: "What could you have done differently?", weekly: true, predefined: true },
  { title: "What are some ways you can take time for yourself?", weekly: false, predefined: true },
  { title: "How do you encourage yourself when you're confronting a challenge?", weekly: false, predefined: true },
  { title: "What's the bravest thing you could do today?", weekly: false, predefined: true },
  { title: "What word sums up your attitude this past year?", weekly: true, predefined: true },
  { title: "What work achievements are you most proud of?", weekly: true, predefined: true },
  { title: "How can you be more productive at work?", weekly: true, predefined: true },
  { title: "What are your greatest strengths and weaknesses in the workplace?", weekly: true, predefined: true },
  { title: "Do you prefer working in a leadership, team, or independent role?", weekly: true, predefined: true },
  { title: "What are your goals for the next year at work?", weekly: true, predefined: true },
  { title: "What is my self-care routine?", weekly: false, predefined: true },
  { title: "What motivates me?", weekly: false, predefined: true },
  { title: "How do I recharge at the end of a long day?", weekly: false, predefined: true }
]

predefined_prompts.each do |prompt|
  Prompt.create!(prompt)
end

puts "Predefined prompts added."

EmotionLogEntry.destroy_all
puts "Existing emotion log entries cleared."
Emotion.destroy_all
puts "Existing emotions cleared."

Emotion.create([
  # Pleasant
  { name: 'happy', color: '#FFD700', icon: 'fa-solid fa-face-smile', category: 'pleasant' },
  { name: 'calm', color: '#00CED1', icon: 'fa-solid fa-leaf', category: 'pleasant' },
  { name: 'excited', color: '#FF8C00', icon: 'fa-solid fa-bolt', category: 'pleasant' },
  { name: 'content', color: '#90EE90', icon: 'fa-solid fa-face-grin-beam', category: 'pleasant' },
  { name: 'hopeful', color: '#87CEEB', icon: 'fa-solid fa-star', category: 'pleasant' },
  { name: 'proud', color: '#FFB6C1', icon: 'fa-solid fa-trophy', category: 'pleasant' },

  # Unpleasant
  { name: 'sad', color: '#1E90FF', icon: 'fa-solid fa-face-frown', category: 'unpleasant' },
  { name: 'tired', color: '#A9A9A9', icon: 'fa-solid fa-bed', category: 'unpleasant' },
  { name: 'angry', color: '#FF6347', icon: 'fa-solid fa-face-angry', category: 'unpleasant' },
  { name: 'anxious', color: '#B22222', icon: 'fa-solid fa-face-meh', category: 'unpleasant' },
  { name: 'frustrated', color: '#8B0000', icon: 'fa-solid fa-face-grimace', category: 'unpleasant' },
  { name: 'lonely', color: '#4682B4', icon: 'fa-solid fa-user-slash', category: 'unpleasant' }
])

puts "Emotions added."

RechargeExercise.destroy_all
puts "Existing recharge exercises cleared."

RechargeExercise.create!([
  { title: "Breathwork 5 Min", description: "Take 5 minutes to focus on slow, deep breathing.", active: true },
  { title: "Stretch Break", description: "Stand up and stretch your arms, legs, and back for 2 minutes.", active: true },
  { title: "Mindful Pause", description: "Close your eyes and notice 5 things you can hear, feel, or smell.", active: true },
  { title: "Hydration Moment", description: "Drink a glass of water slowly and mindfully.", active: true },
  { title: "Step Outside", description: "Go outside for a few minutes and take in your surroundings.", active: true },
  { title: "Gratitude Reflection", description: "Think of one thing you are grateful for right now.", active: true }
])

puts "Recharge exercises added."

GratitudePrompt.destroy_all
puts "Existing gratitude prompts cleared."

GratitudePrompt.create!([
  { title: "What made you smile today?", predefined: true, weekly: false },
  { title: "Who is someone you appreciate and why?", predefined: true, weekly: false },
  { title: "What is something small you are grateful for?", predefined: true, weekly: false },
  { title: "Describe a recent moment of kindness you experienced.", predefined: true, weekly: false },
  { title: "What is a challenge you are grateful for?", predefined: true, weekly: false }
])

puts "Gratitude prompts added."