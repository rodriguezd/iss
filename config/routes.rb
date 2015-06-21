Rails.application.routes.draw do

  root 'pages#home'

  get 'pages/home' => 'pages#home'
  get 'pages/gallery' => 'pages#gallery'
  get 'pages/crew' => 'pages#crew'
  post 'sightings' => 'pages#sightings'

end
