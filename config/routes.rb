ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |f|
  end
  
  map.namespace :facebook do |f|
    f.with_options :controller => 'lobby' do |lobby| 
      lobby.index 'index', :action => 'index'
      lobby.about 'about', :action => 'about'
      lobby.guide 'guide', :action => 'guide'
      lobby.invite 'invite', :action => 'invite'
    end
    
    f.resources :humans, :only => [:index,:show] do |h|
    end
    
    f.resources :pets, :only => [:index,:show,:new,:create], :collection => {:home => :get} do |p|
    end
    
    f.resources :packs, :only => [:new,:create,:show] do |p|
    end
    
    f.resources :occupations, :only => [:index,:update,:create]
    
    f.with_options :path_prefix => '/facebook/pets/home' do |home|
      home.resource :biography, :only => [:new,:create]
      home.resources :messages, :only => [:show,:new,:create,:destroy], :collection => {:inbox => :get, :outbox => :get} 
    end
    
    f.root :controller => 'lobby'
  end

  map.namespace :iphone do |f|
  end
end
