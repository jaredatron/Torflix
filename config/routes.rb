Rails.application.routes.draw do

  scope constraints: lambda { |request| request.accepts.include?(:json) } do
    resources :torrents, only: [:show] do
      get :search, on: :collection
    end

    resources :shows, only: [:index, :show] do
      get :search, on: :collection
    end
  end

  get '*path' => 'app#show'
  root 'app#show'

end
