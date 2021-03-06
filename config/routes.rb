Magellan::Application.routes.draw do
  resources :groups, :shallow => true do
    resources :endpoints, :shallow => true do
      resources :parameter_sets, :shallow => true do
        resources :parameters
        resources :response_members
      end
    end
  end
  
  resources :authentications
  resources :global_parameters
  
  match 'endpoints' => 'endpoints#show'
  match 'endpoints/explore'
  
  match 'setup' => 'home#index', :as => :setup
  
  match 'oauth/callback' => 'authentications#callback', :as => :oauth_callback
  
  root :to => "endpoints#show"
end
