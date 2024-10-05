Rails.application.routes.draw do
  resources :habit_histories do
    delete 'habit/:habit_id', to: 'habit_histories#destroy_by_habit', on: :collection
  end
  resources :users
  resources :habits
  #resources :habits, only: [:index]
  resources :users do
    get 'habits', to: 'habits#index_by_user'
  end
  resources :habits do
    member do
      post 'update_duration'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post '/login', to: 'sessions#create'
end


