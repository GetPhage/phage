Rails.application.routes.draw do
  resources :software_blacklists
  resources :scan_diffs
  resources :samples
  resources :scans
  resources :devices
  resources :networks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
