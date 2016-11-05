Rails.application.routes.draw do


  post 'wx_pay' => 'pay#wx_pay'
  post 'wx_notify' => 'pay#wx_notify'
  root to: 'home#index'
  resource :wechat, only: [:show, :create]

  # ==========================================================================
  # User Authentication
  # ==========================================================================
  resources :users, :module => "users", only: [:show, :new, :update]
  namespace :users do
    get 'otpassword/show'
    get 'otpassword/resend_code'
    post 'otpassword/activate'
  end
  # devise
  devise_for :users, controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # ==========================================================================
  # Sidekiq
  # ==========================================================================
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
