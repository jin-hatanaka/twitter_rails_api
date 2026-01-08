# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    namespace :v1 do
      get 'users/me', to: 'users#me'
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/registrations'
      }
      resources :tweets, only: %i[index show create destroy] do
        resources :comments, only: %i[index]
        resource :retweets, only: %i[create destroy]
        resource :likes, only: %i[create destroy]
      end
      resources :images, only: %i[create]
      resources :users, only: %i[show update]
      resources :comments, only: %i[create destroy]
    end
  end
end
