Rails.application.routes.draw do
  namespace :namespaced do
    resources :things
  end
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
