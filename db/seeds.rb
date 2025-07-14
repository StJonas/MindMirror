# Clear existing prompts
Prompt.where(predefined: true).destroy_all

# Add predefined prompts
predefined_prompts = [
  { title: "What am I grateful for today?", weekly: false, predefined: true },
  { title: "What did I accomplish today?", weekly: false, predefined: true },
  { title: "What did I learn today?", weekly: false, predefined: true },
  { title: "What was my biggest challange this week?", weekly: true, predefined: true },
  { title: "What was my biggest learning this week?", weekly: true, predefined: true },
  { title: "What was my favorite moment of this week?", weekly: true, predefined: true }
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