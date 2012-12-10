Cyberdyne::Application.routes.draw do
  resources :targets

  resources :calls do
    collection do
      get :available_users
    end
  end

  match 'sign_in'  => 'user_sessions#new',     as: :sign_in

  match 'sign_out' => 'user_sessions#destroy', as: :sign_out

  resources :user_sessions, only: [:new, :create, :destroy]

  resources :users

  namespace :twilio do
    resources :calls do
      collection do
        post 'pickup_from_queue'
        get 'dequeued'
        post 'dequeued'
      end
      member do
        post 'hold'
        post 'goodbye'
        post 'user_call'
        post 'phone_number_call'
      end
    end
  end

  root to: 'home#index'
end
