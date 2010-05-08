class Facebook::FacebookController < ApplicationController
  include ApplicationHelper
  include Facebook::FacebookHelper
  layout 'facebook'
  
  helper_method :has_pet?, :has_shop?, :has_pack?, :has_facebook_user?, :application_is_installed?, 
                :facebook_redirect_to, :stored_location
  
  before_filter :ensure_facebook_request, :set_facebook_user
  after_filter :store_location
  
  def has_pet?
    current_user_pet != nil
  end

  def has_shop?
    false
  end

  def has_pack?
    false
  end
  
  def has_facebook_user?
    return (facebook_session != nil && facebook_session.secured?)
  end
  
  def facebook_redirect_to(url)
    redirect_to url
  end  
  
  def store_location
    session[:return_to] = request.request_uri.gsub('facebook/',facebook_root_path)
  end

  def stored_location
    session[:return_to] || facebook_root_path
  end

  def redirect_facebook_back
    redirect_to stored_location, :status => :ok
  end
  
  def ensure_facebook_request
    unless request_comes_from_facebook?
      render :file => "#{RAILS_ROOT}/public/401.html", :status => :unauthorized
      return false
    end
  end
  
  def ensure_has_pet
    unless has_pet?
      render :file => "#{RAILS_ROOT}/public/401.html", :status => :unauthorized
      return false
    end
  end
  
  def set_facebook_user
    if request_comes_from_facebook?
      set_facebook_session 
      
      # if the session is secured then the we have a valid facebook user id
      if has_facebook_user?
        @current_user ||= User.from_facebook(facebook_session.user.uid.to_i,facebook_session)
      end
    end
  end
end