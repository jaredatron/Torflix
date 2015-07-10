Rails.application.routes.draw do

  resources :torrents, only: [:show] do
    get :search, on: :collection
  end

  get '*path' => 'app#show'
  root 'app#show'

end
