ScrapsApp::Application.routes.draw do
  resources :organizations

  root :to => "home#index"
  devise_for :users
end
