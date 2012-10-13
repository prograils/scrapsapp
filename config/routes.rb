ScrapsApp::Application.routes.draw do

  resources :organizations do
    collection do
      get :public
    end
    member do 
      get :members
    end
    
    resources :scraps do 
    
    end
  end

  root :to => "home#index"
  devise_for :users
end
