Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect('/counter')

  resource :counter, only: :show do
    post :deploy
    post :call
    post :double_call
  end
end
