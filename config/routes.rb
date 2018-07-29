Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "accounts#index"
  resources :accounts, except: [:delete]
  resources :categories, except: [:show, :delete]
end
