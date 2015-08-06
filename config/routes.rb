Rails.application.routes.draw do

  root 'main#index'
  put 'parse' => 'main#parse'

  resources :resources, only: [:index]
  mount Resque::Server, :at => "/resque"

end
