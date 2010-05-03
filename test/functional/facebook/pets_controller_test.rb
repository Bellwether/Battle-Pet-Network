require 'test_helper'

class Facebook::PetsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    mock_user_facebooking
  end

  def test_should_get_index_without_pet
    facebook_get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
    assert assigns(:champions)
  end

  def test_should_get_index_with_pet
    facebook_get :index, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'index'
    assert assigns(:pets)
    assert assigns(:champions)
    assert assigns(:friends)
    assert assigns(:rivals)
  end
end