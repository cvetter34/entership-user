Rails.application.routes.draw do

  root 'site#index'                                                       # works

  get    'about'          => 'site#about',          as: :about_us         # works
  get    'privacy'        => 'site#privacy',        as: :privacy_policy   # works
  get    'terms'          => 'site#terms',          as: :terms_of_use     # works
  get    'education'      => 'site#education',      as: :education

  get    'contact'        => 'contacts#new',        as: :contact_us       #
  post   'contact'        => 'contacts#create'

  # Log in/out
  post   'login'          => 'session#create',      as: :log_in           # works
  delete 'logout'         => 'session#destroy',     as: :log_out          # works

  # Registration
  get    'register/:code' => 'registration#new',    as: :registration_form
  post   'register/:code' => 'registration#create', as: :register

  # Password reset
  get    'reset/:code'    => 'password#edit',       as: :password_reset_form
  patch  'reset/:code'    => 'password#update',     as: :reset_password

  # Email verification
  get    'verify/:code'   => 'email#update',        as: :email_verification

  # Member profile
  get    'profile'        => 'profile#show',        as: :profile
  get    'profile/edit'   => 'profile#edit',        as: :edit_profile
  patch  'profile'        => 'profile#update'
  delete 'profile'        => 'profile#destroy'

  resources :members, only: [ :index, :show ]

  resources :companies, only: [ :index, :show ]

  resources :jobs, only: [ :index, :show ] do
    resources :apps
  end

  resources :apps, only: [ :index, :show ]
end
