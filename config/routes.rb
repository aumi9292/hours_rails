Rails.application.routes.draw do
  resources :employees, only: [:index, :show] do
    resources :pay_periods, only: [] do 
      resources :date_hours, only: [:index]
    end
  end
  resources :date_hours, only: [:create]
end
