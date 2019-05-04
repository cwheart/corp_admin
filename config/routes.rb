Rails.application.routes.draw do
  resources :corps do
    collection do
      get :export
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
