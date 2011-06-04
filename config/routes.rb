Caritas::Application.routes.draw do

  scope "(:locale)" do
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
    match '/search' => 'search#index', :as => 'search'

  end # scope(:locale)

  root :to => 'projects#index'
  match '/:locale' => 'projects#index'
  match '/admin/dashboard', :to => "admin/dashboard#index"
end
