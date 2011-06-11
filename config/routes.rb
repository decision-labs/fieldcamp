Caritas::Application.routes.draw do

  resources :articles

  scope "(:locale)" do
    match '/public', :to => 'application#public', :as => :public

    match '/search' => 'search#index', :as => 'search'
    match '/search/locations' => 'search#locations', :as => 'search_locations'
    match '/admin/dashboard', :to => "admin/dashboard#index"

    devise_for :users

    root :to => 'application#public', :constraints => lambda {|r| !r.env["warden"].authenticate? }

    authenticate :user do
      root :to => "admin/dashboard#index"
    end


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

  match '/:locale' => 'projects#index'
end
