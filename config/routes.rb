ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources :rsvps, 
                :collection => {
                  :send_reminders => :post
                },
                :member => {
                  :clear => :put, 
                  :mine  => [:get,:put],
                  :toggle_reservation => :put
                }
  
  map.site    ':page',  :controller => 'site',  :action => 'show'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  
end
