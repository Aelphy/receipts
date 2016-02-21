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
      match  'receipts'      => 'receipts#index',        via: [:get, :options]
      match  'receipts/:id'  => 'receipts#show',         as: :receipt,
                                                         via: [:get, :options]
      match  'receipts/:id'  => 'receipts#update',       as: :update_receipt,
                                                         via: [:patch, :put]

      post   'receipts'      => 'receipts#create'

      delete 'auth/token'    => 'sessions#delete',      as: :logout
      delete 'receipts/:id'  => 'receipts#delete',      as: :delete_receipt

      scope 'receipts/:receipt_id', as: :receipt do
        match 'items'      => 'items#index',  as: :items, via: [:get, :options]
        match 'items/:id'  => 'items#show',   as: :item, via: [:get, :options]
        match 'items/:id'  => 'items#update', via: [:patch, :put]

        post 'items'       => 'items#create'

        delete 'items/:id' => 'items#delete'
      end
    end
  end

  match '*path' => 'others#not_found', via: [:get,
                                             :post,
                                             :put,
                                             :patch,
                                             :options,
                                             :delete]
end
