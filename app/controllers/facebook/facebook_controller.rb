class Facebook::FacebookController < ApplicationController
  include ApplicationHelper
  include FacebookHelper
  
  before_filter :require_facebook_request
  
  def require_facebook_request
    unless request_comes_from_facebook?
      render :file => "#{RAILS_ROOT}/public/401.html", :status => :unauthorized
      return false
    end
  end
end