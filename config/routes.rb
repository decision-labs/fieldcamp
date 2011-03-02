Caritas::Application.routes.draw do

  scope "(:locale)" do
    devise_for :users

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
