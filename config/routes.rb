Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "homes#show"

  resource :login, only: [:show, :create]
  devise_for :users
  devise_scope :user do
    get :logout, to: 'devise/sessions#destroy'
  end

  resource :counter, only: :show do
    post :deploy
    post :call
    post :double_call
  end
end
