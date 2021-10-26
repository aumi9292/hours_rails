Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :employees do
    resources :pay_periods do 
      resources :date_hours
    end
  end
end
