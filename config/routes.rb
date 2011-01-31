ProjectManager::Application.routes.draw do
  resources :locations

  scope "(:locale)" do
    resources :projects
    resources :people
  end

  root :to => 'application#index'
  match '/:locale' => 'application#index'
end
