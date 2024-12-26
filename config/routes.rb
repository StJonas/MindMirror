Rails.application.routes.draw do
  resources :habit_histories do
    delete 'habit/:habit_id', to: 'habit_histories#destroy_by_habit', on: :collection
  end
  resources :users do
    get 'prompts', to: 'prompts#user_prompts'
    get 'habits', to: 'habits#index_by_user'
    get 'journal_entries', to: 'journal_entries#user_journal_entries'
    resources :habits do
      get 'habit_histories/week', to: 'habit_histories#week'
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

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'sessions#create'
end