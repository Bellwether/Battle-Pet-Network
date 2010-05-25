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
      p.resources :challenges, :only => [:new,:create]
      p.resources :signs, :only => [:create]
    end
    
    f.resources :packs, :only => [:new,:create,:show] do |p|
    end
    
    f.resources :sentients, :only => [:index,:show] do |s|
      s.resources :hunts, :only => [:new,:create]
    end
    
    f.resources :items, :only => [:index], :member => {:store => :get, :purchase => :post}, :collection => {:premium => :get} do |i|
    end
    
    f.resources :shops, :only => [:index, :show] do |s|
      s.resources :inventory, :only => [], :member => {:purchase => :post}
    end
    
    f.resources :leaderboards, :only => [:index]
    
    f.resources :occupations, :only => [:index,:update], :member => {:attempt => :put}
    
    f.with_options :path_prefix => '/facebook/pets/home' do |home|
      home.resource :biography, :only => [:new,:create]
      home.resources :messages, :only => [:show,:new,:create,:destroy], :collection => {:inbox => :get, :outbox => :get} 
      home.resources :kennel, :only => [:index], :member => {:enslave => :put, :release => :put}, :controller => 'tames'
      home.resources :challenges, :only => [:index,:edit,:show], :member => {:refuse => :put, :cancel => :put}
      home.resources :hunts, :only => [:show]
      home.resources :battles, :only => [:show]
      home.resource :shop, :only => [:new,:create,:edit,:update] 
      home.resource :pack, :only => [:edit,:update], :member => {:invite => :post} do |pack|
        pack.resources :spoils, :only => [:create,:update]
      end
      home.resources :belongings, :only => [:index,:update]
      home.combat 'combat', :controller => 'pets', :action => 'combat'
    end
    
    f.resources :payment_orders, :only => [:create] do |po|
      po.resources :payment_order_transactions, :only => [:new]
    end
    
    f.root :controller => 'lobby'
  end

  map.namespace :iphone do |f|
  end
end
