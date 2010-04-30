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
  end

  map.namespace :iphone do |f|
  end
end
