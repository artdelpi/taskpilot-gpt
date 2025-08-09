Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, path: 'account',
    controllers: { registrations: 'users/registrations' }

  authenticated :user do
    root "projects#index", as: :authenticated_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :projects
  resources :tasks do
    member do
      get :split_with_ai
      post :save_subtasks
      post :assign
      get :prioritize_with_ai
      post :apply_priority_order
    end

    resources :comments, only: [:create, :destroy]
    resources :attachments, only: [:create, :destroy]
    resources :task_assignments, only: [:create, :destroy]
    resources :task_dependencies, only: [:create, :destroy]
  end

  resources :tags
  resources :users, only: [:index, :show]
end
