Rails.application.routes.draw do
  resources :geo_ips
  resources :geo_locations
  resources :histories
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  root to: 'dashboard#index'

  resources :services
  resources :cves
  resources :manufacturers
  resources :partial_flows
  resources :flows
  resources :mdns
  resources :upnps
  resources :ouis
  resources :products
  resources :product_categories
  resources :software_blacklists
  resources :scan_diffs
  resources :samples
  resources :scans
  resources :devices
  resources :networks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'
  mount BeanstalkdView::Server, :at => "/beanstalkd"
end
