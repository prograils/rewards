RewardsThem::Application.routes.draw do

  devise_for :admin_users
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: [:index, :show]
  put 'change_period', to: 'users#change_period'
  post 'update_users', to: 'users#update_users'
  post 'set_default_limit', to: 'users#set_default_limit'

  resources :rewards, only: [:new, :create, :index, :show] do
    resources :comments, only: [:new, :create]
  end

  authenticated :user do
    root to: 'rewards#index', as: :user_root
  end
  root to: 'home#index'
end
