Caritas::Application.routes.draw do

  resources :articles

  scope "(:locale)" do
    match '/search' => 'search#index', :as => 'search'
    match '/search/locations' => 'search#locations', :as => 'search_locations'
    match '/admin/dashboard', :to => "admin/dashboard#index"

    devise_for :users
    get 'settings' => 'settings#show'
    get 'settings/edit' => 'settings#edit', :as => 'edit_settings'
    put 'settings' => 'settings#update'

    # CHECK: if doing ajax is faster than using the cached geometry
    # get 'locations/:id/events' => 'locations#show', :defaults => {:format => "json", :events => true }

    resources :locations
    resources :partners
    resources :sectors

    resources :projects do
      resources :events
    end

  end # scope(:locale)

  root :to => 'projects#index'
  match '/:locale' => 'projects#index'
end
