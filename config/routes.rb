Rails.application.routes.draw do
  resources :users, only: [:index, :create] do
    collection do
      post 'login'
    end
  end

  resources :employees, only: [:index, :show] do
    resources :pay_periods, only: [] do
      resources :date_hours, only: [:index]
    end
  end

  resources :date_hours, only: [:create]

  put '/date_hours', to: 'date_hours#update'
end
