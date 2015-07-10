Rails.application.routes.draw do

  namespace :torrents do
    get :search
  end

  get '*path' => 'app#show'
  root 'app#show'

end
