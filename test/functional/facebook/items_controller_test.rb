require 'test_helper'

class Facebook::ItemsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def test_index
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert_tag :tag => "table", :attributes => { :class => "item-store" }
    assert_tag :tag => "span", :attributes => { :class => "shopping-button" }
  end
end