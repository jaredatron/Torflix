Rails.application.routes.draw do

  get '*path' => 'app#show'
  root 'app#show'

end
