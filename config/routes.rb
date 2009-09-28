ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources :rsvps, 
                :member => {:clear => :put, :mine => [:get,:put]}
  
  map.site    ':page',  :controller => 'site',  :action => 'show'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  
end
