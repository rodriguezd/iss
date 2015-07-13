Rails.application.routes.draw do

  root 'pages#home'

  get 'pages/home' => 'pages#home'
  get 'pages/gallery' => 'pages#gallery'
  get 'pages/crew' => 'pages#crew'
  get 'pages/video_feeds' => 'pages#video_feeds'
  post 'sightings' => 'pages#sightings'

end
