Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "accounts#index"
  resources :accounts, except: [:delete] do
    resources :activities, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :categories, except: [:show, :delete]

  resources :merchants, only: [] do
    get 'autocomplete', on: :collection
  end

end
