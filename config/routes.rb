Rails.application.routes.draw do

  get '*path' => 'app#show'

end
