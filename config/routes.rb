Rails.application.routes.draw do
  resources :emotion_log_entries
  resources :emotion_logs
  resources :emotions
  resources :gratitude_entries
  resources :tags
  resources :gratitude_prompts
  resources :habit_histories do
    delete 'habit/:habit_id', to: 'habit_histories#destroy_by_habit', on: :collection
  end
  resources :users do
    get 'prompts', to: 'prompts#user_prompts'
    get 'habits', to: 'habits#index_by_user'
    get 'journal_entries', to: 'journal_entries#user_journal_entries'
    resources :habits do
      get 'habit_histories/week', to: 'habit_histories#week'
      get 'habit_histories/date', to: 'habit_histories#by_date'
    end
    get 'habit_histories', to: 'habit_histories#user_histories'
  end
  resources :habits do
    member do
      post 'update_duration'
    end
  end
  resources :prompts
  resources :journal_entries
  resources :users do
    resources :gratitude_entries, only: [:index, :create, :show, :update, :destroy]
  end
  resources :users do
    get 'gratitude_prompts', to: 'gratitude_prompts#user_gratitude_prompts'
  end
  resources :habits do
    get 'habit_histories/date', to: 'habit_histories#by_date'     # <-- add this line if you want /habits/:habit_id/habit_histories/date
  end
  resources :users do
    get 'habit_log', to: 'habit_histories#log_by_user'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'sessions#create'
end