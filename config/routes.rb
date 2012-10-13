ScrapsApp::Application.routes.draw do


  get "starred" => "dashboard#starred", :as=>:starred
  get "observed" => "dashboard#observed", :as=>:observed

  resources :organizations do
    collection do
      get :public
    end
    member do 
      get :members
      get :observe
      get :stop_observing
    end
    
    resources :scraps do 
    
    end
  end

  devise_for :users
  authenticated :user do
    root :to => 'dashboard#index'
  end
  root :to => "home#index"
end
