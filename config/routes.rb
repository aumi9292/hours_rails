Rails.application.routes.draw do

  #devise_for :users, defaults: { format: :json }

  #resources :sessions, only: [:create, :destroy]

  root to: "employees#index" # added for devise

  resources :employees, only: [:index, :show] do
    resources :pay_periods, only: [] do
      resources :date_hours, only: [:index]
    end
  end
  resources :date_hours, only: [:create]

  put '/date_hours', to: 'date_hours#update'

  devise_for :users,
    controllers: {
        sessions: 'sessions',
        registrations: 'registrations'
    },
    defaults: { format: :json }

  get '/member-data', to: 'members#show'
end
