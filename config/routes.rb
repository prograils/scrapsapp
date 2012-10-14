ScrapsApp::Application.routes.draw do


  get "starred" => "dashboard#starred", :as=>:starred
  get "observed" => "dashboard#observed", :as=>:observed
  get "my" => "dashboard#my", :as=>:my
  get "delete_oauth/:id" => "dashboard#delete_oauth", :as=>:delete_oauth

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
      member do
        get :star
        get :unstar
      end
    
    end
  end

  devise_for :users, :controllers => {
                                :registrations  => "users/registrations",
                                :sessions  => "users/sessions"
                              }
  match 'auth/:provider/callback', to: 'omniauth_callbacks#callback'
  match 'auth/failure', to: redirect('/')
  authenticated :user do
    root :to => 'dashboard#index'
  end
  root :to => "home#index"
end
