ProjectManager::Application.routes.draw do
  resources :locations

  scope "(:locale)" do
    resources :people

    resources :projects do
      resources :events
    end
  end # scope(:locale)

  root :to => 'projects#index'
  match '/:locale' => 'projects#index'
end
