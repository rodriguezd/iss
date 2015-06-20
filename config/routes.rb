Rails.application.routes.draw do

  root 'pages#home'

  get 'pages/home' => 'pages#home'
  post 'sightings' => 'pages#sightings'

end
