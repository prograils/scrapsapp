ScrapsApp::Application.routes.draw do


  get "starred" => "dashboard#starred", :as=>:starred
  get "observed" => "dashboard#observed", :as=>:observed
  get "my" => "dashboard#my", :as=>:my
  get "delete_oauth/:id" => "dashboard#delete_oauth", :as=>:delete_oauth

  resources :organizations, :path=>"o" do
    collection do
      get :public
    end
    member do
      get :members
      get :observe
      get :stop_observing
    end

    resources :folders, :path=>"f" do
      resources :scraps, :path=>"s", :only=>[:show, :index]
    end
    resources :scraps, :path=>"s" do
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
  get 'auth/:provider/callback', to: 'omniauth_callbacks#callback'
  get 'auth/failure', to: redirect('/')
  authenticated :user do
    root :to => 'dashboard#index', as: :user_root
  end
  root :to => "home#index"
end
