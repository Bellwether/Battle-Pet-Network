require 'test_helper'

class Facebook::BelongingsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:two)
    @pet = @user.pet
  end
  
  def test_index
    mock_user_facebooking(@user.facebook_id)
    facebook_get :index, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'index'
    assert !assigns(:items).blank?
    assert !assigns(:gear).blank? 
    assert_tag :tag => "table", :attributes => { :class => "item"}
  end
end