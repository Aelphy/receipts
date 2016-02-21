Rails.application.routes.draw do
  # Authentication
  namespace :api do
    namespace :v1 do
      match  'users'         => 'users#create',          as: :sign_up,
                                                         via: [:post, :options]
      match  'auth/password' => 'users#new_password',    as: :new_password,
                                                         via: [:post, :options]
      match  'auth/token'    => 'sessions#create',       as: :sign_in,
                                                         via: [:post, :options]
      match  'notifications' => 'notifications#index',   via: [:get, :options]
      delete 'auth/token'    => 'sessions#destroy',      as: :logout
    end
  end

  match '*path' => 'others#not_found', via: [:get,
                                             :post,
                                             :put,
                                             :patch,
                                             :options,
                                             :delete]
end
