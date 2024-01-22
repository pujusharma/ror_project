Rails.application.routes.draw do

  
  resources :products  
    get '/profile', to: 'home#profile'
    get 'text_to_speech', to: 'speech#text_to_speech_form'
    get 'speech_to_text', to: 'speech#speech_to_text_form'
  post 'text_to_speech_display', to: 'speech#text_to_speech', as: 'text_to_speech_display'
  get '/output.mp3', to: 'speech#output_audio' 
  post '/speech_to_text', to: 'speech#speech_to_text'
  post 'speech_to_text_display', to: 'speech#speech_to_text', as: 'speech_to_text_display'
  root 'products#index'  
  get 'home/index'
  get '/contact', to: "home#contact"
  post '/contact_email', to: "home#contact_email" , as: "contact_email"
  get '/about', to: "home#about"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
