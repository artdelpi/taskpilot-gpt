Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :tasks do
    member do
      get :split_with_ai
      post :save_subtasks
      post :assign
      get :prioritize_with_ai
      post :apply_priority_order
    end
  end

end
