class Facebook::FacebookController < ApplicationController
  include ApplicationHelper
  include Facebook::FacebookHelper
  
  helper_method :has_pet?, :has_shop?, :has_pack?
  
  before_filter :ensure_facebook_request
  
  def has_pet?
    false
  end

  def has_shop?
    false
  end

  def has_pack?
    false
  end
  
  def ensure_facebook_request
    unless request_comes_from_facebook?
      render :file => "#{RAILS_ROOT}/public/401.html", :status => :unauthorized
      return false
    end
  end
end