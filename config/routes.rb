Lobby::Engine.routes.draw do

  root to: 'sessions#new'

  post 'log_in' => 'sessions#create', as: 'log_in'
  get 'log_in' => 'sessions#new', as: 'log_in_link'
  match 'confirm/resend_confirmation' => 'confirmation#resend_signup_token', as: 'resend_signup_token', via: [:get, :post]
  match 'confirm/:action(/:token)', :controller => :confirmation, as: 'confirm', via: [:get, :post]
  post 'register' => 'users#create', as: 'sign_up'
  get 'register' => 'users#new', as: 'sign_up_form'
  get 'log_out' => 'sessions#destroy', as: 'log_out'

  # forgotten password
  get 'recover_password(/:token)' => 'password_forgotten#new', as: 'recover_password_form'
  post 'recover_password' => 'password_forgotten#create', as: 'recover_password'
  match 'request_password' => 'password_forgotten#order_new_password', as: 'order_new_password', via: [:get, :post]

  resources :sessions

  default_url_options  :host => 'localhost:3000'
end
