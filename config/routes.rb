Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_for :admins

  authenticated :admin do
    root to: 'admin#index', as: :authenticated_admin_root
  end

  namespace :admin do
    root to: 'dashboard#index', as: :root
    resources :deliveries
    resources :packages
    resources :categories

  end
  resources :drivers do
    put :assign_delivery_to_package, on: :collection


  end
  resources :clients do
    put :link_package_to_delivery, on: :collection

  end
  get 'client/dashboard', to: 'clients#dashboard', as: :client_dashboard
  get 'driver/dashboard', to: 'drivers#dashboard', as: :driver_dashboard
  get 'driver/profile', to: 'drivers#profile', as: :driver_profile
  get 'client/profile', to: 'clients#profile', as: :client_profile
  get 'client/messages', to: 'clients#messages', as: :client_messages
  get 'client/messages/:id/details', to: 'clients#messages_details', as: :client_message_details
  get 'my_packages', to: 'clients#my_packages', as: :my_packages
  get 'packages/new', to: 'clients#new_package', as: :new_package
  post 'packages', to: 'clients#create_package', as: :create_package
  get 'packages/:id/edit', to: 'clients#edit_package', as: :edit_package
  patch 'packages/:id', to: 'clients#update_package', as: :update_package
  delete 'packages/:id', to: 'clients#destroy_package', as: :destroy_package
  get 'driver/messages', to: 'drivers#messages', as: :driver_messages
  get 'driver/messages/:id/details', to: 'drivers#messages_details', as: :driver_message_details

  get 'driver/deliveries', to: 'drivers#deliveries', as: :driver_deliveries
  get 'driver/deliveries/new', to: 'drivers#new_delivery', as: :new_driver_delivery
  post 'driver/deliveries', to: 'drivers#create_delivery', as: :create_driver_delivery
  get 'driver/deliveries/:id/edit', to: 'drivers#edit_delivery', as: :edit_driver_delivery
  patch 'driver/deliveries/:id', to: 'drivers#update_delivery', as: :update_driver_delivery
  delete 'driver/deliveries/:id', to: 'drivers#destroy_delivery', as: :destroy_driver_delivery
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'packages/:id', to: 'drivers#show', as: :package
  get 'deliveries/:id', to: 'clients#show', as: :delivery
  get 'client/deliveries/:id/pay', to: 'clients#pay', as: 'pay_client_delivery', constraints: { id: /\d+/ }
  get 'payments/confirm', to: 'clients#confirm_payment', as: :confirm_payment
  resources :reviews, only: [:create]

  resources :messages, only: [:create]
  root 'home#index'
end
