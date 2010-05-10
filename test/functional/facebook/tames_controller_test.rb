require 'test_helper'

class Facebook::TamesControllerTest  < ActionController::TestCase
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
    assert !assigns(:tames).blank?
    assert !assigns(:slave_count).blank?
    assert_tag :tag => "strong", :attributes => { :id => "slave-earnings" }
    assert_tag :tag => "table", :attributes => { :class => "kennels"}, :descendant => { 
      :tag => "table", :attributes => { :class => "domesticated-human" }
    }
  end
end