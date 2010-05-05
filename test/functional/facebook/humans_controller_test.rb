require 'test_helper'

class Facebook::HumansControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def test_should_get_index_without_pet
    mock_user_facebooking
    facebook_get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:humans)
  end

  def test_should_get_index_with_pet
    mock_user_facebooking(users(:one).facebook_id)
    facebook_get :index, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'index'
    assert assigns(:humans)
  end
  
  def test_should_get_human
    facebook_get :show, :id => humans(:sarah).id, :fb_sig_user => nil
    assert_response :success
    assert_template 'show'
    assert assigns(:human)
  end
end