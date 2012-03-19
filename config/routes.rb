Caritas::Application.routes.draw do

  resources :images

  scope "(:locale)" do
    match "/events_feed", :to => "events_feed#index",  :as => "events_feed"
    match '/public', :to => 'public#index', :as => :public

    match '/search/locations' => 'search#locations',  :as => 'search_locations'
    match '/search/partners'  => 'search#partners',   :as => 'search_partners'
    match '/search/sectors'   => 'search#sectors',    :as => 'search_sectors'
    match '/search'           => 'search#projects',   :as => 'search'
    match '/search/projects'  => 'search#projects',   :as => 'search_projects'
    match '/search/events'    => 'search#events',     :as => 'search_events'
    match '/admin/dashboard', :to => "admin/dashboard#index", :as => 'dashboard'

    devise_for :users

    root :to => 'public#index', :constraints => lambda {|r| !r.env["warden"].authenticate? }

    authenticate :user do
      root :to => "admin/dashboard#index"
    end

    get 'settings' => 'settings#show'
    get 'settings/edit' => 'settings#edit', :as => 'edit_settings'
    put 'settings' => 'settings#update'

    # CHECK: if doing ajax is faster than using the cached geometry
    # get 'locations/:id/events' => 'locations#show', :defaults => {:format => "json", :events => true }

    resources :articles do
      get 'projects', :on => :collection
      put 'unpublish', :on => :member
    end

    resources :locations
    resources :partners
    resources :sectors

    resources :projects do
      resources :events
      resources :articles, :only => [:show]
    end

  end # scope(:locale)

  match '/:locale' => 'projects#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
