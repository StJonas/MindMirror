# # Clear existing prompts
# Prompt.where(predefined: true).destroy_all

# # Add predefined prompts
# predefined_prompts = [
#   { title: "What are you proud of yourself for today?", weekly: false, predefined: true },
#   { title: "What did I accomplish today?", weekly: false, predefined: true },
#   { title: "What did I learn today?", weekly: false, predefined: true },
#   { title: "What was my biggest challange this week?", weekly: true, predefined: true },
#   { title: "What was my biggest learning this week?", weekly: true, predefined: true },
#   { title: "What was my favorite moment of this week?", weekly: true, predefined: true },
#   { title: "What did you learn today?", weekly: false, predefined: true },
#   { title: "What strengths did you use today?", weekly: false, predefined: true },
#   { title: "What challenges did you overcome?", weekly: false, predefined: true },
#   { title: "What are the most valuable lessons you've learned from past experiences?", weekly: true, predefined: true },
#   { title: "What were some of the most interesting discoveries you made while working on this project?", weekly: true, predefined: true },
#   { title: "What are some things that challenged your thinking, or that you disagree with?", weekly: true, predefined: true },
#   { title: "What could you have done differently?", weekly: true, predefined: true },
#   { title: "What are some ways you can take time for yourself?", weekly: false, predefined: true },
#   { title: "How do you encourage yourself when you're confronting a challenge?", weekly: false, predefined: true },
#   { title: "What's the bravest thing you could do today?", weekly: false, predefined: true },
#   { title: "What word sums up your attitude this past year?", weekly: true, predefined: true },
#   { title: "What work achievements are you most proud of?", weekly: true, predefined: true },
#   { title: "How can you be more productive at work?", weekly: true, predefined: true },
#   { title: "What are your greatest strengths and weaknesses in the workplace?", weekly: true, predefined: true },
#   { title: "Do you prefer working in a leadership, team, or independent role?", weekly: true, predefined: true },
#   { title: "What are your goals for the next year at work?", weekly: true, predefined: true },
#   { title: "What is my self-care routine?", weekly: false, predefined: true },
#   { title: "What motivates me?", weekly: false, predefined: true },
#   { title: "How do I recharge at the end of a long day?", weekly: false, predefined: true }
# ]

# predefined_prompts.each do |prompt|
#   Prompt.create!(prompt)
# end

# puts "Predefined prompts added."

# EmotionLogEntry.destroy_all
# puts "Existing emotion log entries cleared."
# Emotion.destroy_all
# puts "Existing emotions cleared."

# Emotion.create([
#   # Pleasant
#   { name: 'happy', color: '#FFED01', icon: 'fa-solid fa-face-smile', category: 'pleasant' },      # softer yellow
#   { name: 'calm', color: '#4CA5C4', icon: 'fa-solid fa-leaf', category: 'pleasant' },             # softer teal
#   { name: 'loved', color: '#FF78BE', icon: 'fa-solid fa-heart', category: 'pleasant' },          # softer pink
#   { name: 'excited', color: '#FF9E52', icon: 'fa-solid fa-bolt', category: 'pleasant' },          # softer orange
#   { name: 'content', color: '#58F400', icon: 'fa-solid fa-face-grin-beam', category: 'pleasant' },# softer green
#   { name: 'hopeful', color: '#66BAFA', icon: 'fa-solid fa-star', category: 'pleasant' },          # softer blue

#   # Unpleasant
#   { name: 'sad', color: '#59B7FF', icon: 'fa-solid fa-face-frown', category: 'unpleasant' },      # softer blue
#   { name: 'tired', color: '#D3D3D3', icon: 'fa-solid fa-bed', category: 'unpleasant' },           # lighter gray
#   { name: 'angry', color: '#FF7663', icon: 'fa-solid fa-face-angry', category: 'unpleasant' },    # softer red
#   { name: 'anxious', color: '#E67370', icon: 'fa-solid fa-face-meh', category: 'unpleasant' },    # softer dark red
#   { name: 'frustrated', color: '#D16A66', icon: 'fa-solid fa-face-tired', category: 'unpleasant' }, # softer dark red
#   { name: 'stressed', color: '#7976E6', icon: 'fa-solid fa-face-rolling-eyes', category: 'unpleasant' }    # softer blue
# ])

# puts "Emotions added."

RechargeExercise.destroy_all
puts "Existing recharge exercises cleared."

RechargeExercise.create!([
  { title: "Breathwork 5 Min", description: "Take 5 minutes to focus on slow, deep breathing.", active: true },
  { title: "Stretch Break", description: "Stand up and stretch your arms, legs, and back for 2 minutes.", active: true },
  { title: "Mindful Pause", description: "Close your eyes and notice 5 things you can hear, feel, or smell.", active: true },
  { title: "Hydration Moment", description: "Drink a glass of water slowly and mindfully.", active: true },
  { title: "Step Outside", description: "Go outside for a few minutes and take in your surroundings.", active: true },
  { title: "Mini Meditation", description: "Sit quietly and focus on your breath for 3 minutes.", active: true },
  { title: "Nature Glance", description: "Look out the window or at a plant and notice its details.", active: true },
  { title: "Music Pause", description: "Listen to your favorite song without doing else.", active: true },
  { title: "Body Scan", description: "Close your eyes and mentally scan your body from head to toe.", active: true },
  { title: "Positive Affirmation", description: "Repeat a positive affirmation to yourself three times.", active: true },
  { title: "Quick Walk", description: "Take a brisk 5-minute walk.", active: true },
  { title: "Creative Doodle", description: "Spend 2 minutes doodling or drawing freely.", active: true },
  { title: "Shoulder Roll", description: "Roll your shoulders forward and backward 10 times.", active: true },
  { title: "Digital Detox", description: "Put your phone away and disconnect from all screens for 5 minutes.", active: true },
  { title: "Gratitude Reflection", description: "Think of three things you are grateful for right now.", active: true },
  { title: "Positive Visualization", description: "Close your eyes and visualize a peaceful scene for 3 minutes.", active: true },
  { title: "Gentle Neck Stretch", description: "Gently tilt your head side to side to stretch your neck.", active: true },
  { title: "Quick Journaling", description: "Write down your thoughts or feelings for 5 minutes.", active: true },
  { title: "Positive Memory", description: "Recall a happy memory and immerse yourself in the feelings it brings.", active: true },
  { title: "Gentle Breathing", description: "Inhale deeply for 4 seconds, hold for 4 seconds, exhale for 4 seconds, repeat for 5 cycles.", active: true },
  { title: "Positive Self-Talk", description: "Spend a minute talking positively to yourself about your day or week.", active: true },
  { title: "Stretch and Breathe", description: "Do a simple stretch while focusing on your breath for 2 minutes.", active: true },
  { title: "Mindful Observation", description: "Pick an object in the room and observe it closely for 2 minutes.", active: true }
])

puts "Recharge exercises added."

# GratitudePrompt.destroy_all
# puts "Existing gratitude prompts cleared."

# GratitudePrompt.create!([
#   { title: "What made you smile today?", predefined: true, weekly: false },
#   { title: "Who is someone you appreciate and why?", predefined: true, weekly: false },
#   { title: "What is something small you are grateful for?", predefined: true, weekly: false },
#   { title: "Describe a recent moment of kindness you experienced.", predefined: true, weekly: false },
#   { title: "What is a challenge you are grateful for?", predefined: true, weekly: false }
# ])

# puts "Gratitude prompts added."