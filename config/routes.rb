Rails.application.routes.draw do
  resources :ouis
  resources :products
  resources :product_categories
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :software_blacklists
  resources :scan_diffs
  resources :samples
  resources :scans
  resources :devices
  resources :networks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount BeanstalkdView::Server, :at => "/beanstalkd"
end
