Caritas::Application.routes.draw do


  resources :images

  scope "(:locale)" do
    match "/events_feed", :to => "events_feed#index",  :as => "events_feed"
    match '/public', :to => 'application#public', :as => :public

    match '/search/locations' => 'search#locations',  :as => 'search_locations'
    match '/search/partners'  => 'search#partners',   :as => 'search_partners'
    match '/search/sectors'   => 'search#sectors',    :as => 'search_sectors'
    match '/search'           => 'search#projects',   :as => 'search'
    match '/admin/dashboard', :to => "admin/dashboard#index", :as => 'dashboard'

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

    resources :articles
    resources :locations
    resources :partners
    resources :sectors

    resources :projects do
      resources :events
    end

  end # scope(:locale)

  match '/:locale' => 'projects#index'
end
