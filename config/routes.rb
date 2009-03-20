ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :user_session
  
  map.root :controller => "runs", :action => 'index'
  
  map.resources :runs, :member => {:approve => :post, 
                                   :load_data => :get, 
                                   :data => :put, 
                                   :toggle_point => :post,
                                   :delete_data => :delete}


  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
