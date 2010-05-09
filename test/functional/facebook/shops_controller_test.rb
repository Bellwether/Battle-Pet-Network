require 'test_helper'

class Facebook::ShopsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @shop = shops(:first)
  end

  def test_index
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert_tag :tag => "table", :attributes => { :id => "shops" }
    assert !assigns(:shops).blank?
    assert !assigns(:shop_filter_types).blank?
    assert !assigns(:filters).blank?
  end
  
  def test_index_search
  end
  
  def test_index_filter
  end
end