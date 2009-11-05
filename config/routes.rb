ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'site'
  
  map.resources :rsvps, 
                :collection => {
                  :send_reminders => :post,
                  :send_upcoming_reminders => :post
                },
                :member => {
                  :clear => :put, 
                  :mine  => [:get,:put],
                  :toggle_reservation => :put,
                  :survey => [:get,:post]
                }
  
  map.site    ':page',  :controller => 'site',  :action => 'show'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  
end
