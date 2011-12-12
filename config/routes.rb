FbBase::Application.routes.draw do
  get 'facebook/show/:id' => 'facebook#show', as: :friend
  match 'facebook/:action' => 'facebook', :as => :facebook
  root :to => 'facebook#index'
end
