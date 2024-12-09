Rails.application.routes.draw do
  resources :habit_histories do
    delete 'habit/:habit_id', to: 'habit_histories#destroy_by_habit', on: :collection
  end
  resources :users
  resources :habits
  resources :prompts
  resources :journal_entries
  resources :users do
    get 'habits', to: 'habits#index_by_user'
  end
  resources :habits do
    member do
      post 'update_duration'
    end
  end
  
  resources :users do
    resources :habits do
      get 'habit_histories/week', to: 'habit_histories#week'
    end
    get 'habit_histories', to: 'habit_histories#user_histories'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'sessions#create'
end


