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

Emotion.create([
  { name: 'happy', color: '#FFD700', icon: 'fa-solid fa-face-smile' },
  { name: 'sad', color: '#1E90FF', icon: 'fa-solid fa-face-frown' },
  { name: 'tired', color: '#A9A9A9', icon: 'fa-solid fa-bed' },
  { name: 'calm', color: '#00CED1', icon: 'fa-solid fa-leaf' }
])

puts "Emotions added."