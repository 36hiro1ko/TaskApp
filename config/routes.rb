Rails.application.routes.draw do
  #get 'layouts/index'

  resources :tasks
  #root to: 'tasks#index'
  root :to => "layouts#index"


 
end
