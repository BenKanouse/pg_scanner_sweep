Rails.application.routes.draw do
  resources :pg_stat_activities, only: [:index, :show], defaults: { format: 'json' }
  get 'main/index'
  root 'main#index'
end
