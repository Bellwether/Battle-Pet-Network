require 'test_helper'

class Facebook::LobbyControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    mock_user_facebooking
  end
  
  def test_should_get_index
    facebook_get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_should_get_about
    facebook_get :about
    assert_response :success
    assert_template 'about'
  end
  
  def test_should_get_guide
    facebook_get :guide
    assert_response :success
    assert_template 'guide'
  end
  
  def test_should_get_invite
    facebook_get :invite, :fb_sig_user => users(:one).facebook_id
    assert_response :success
    assert_template 'invite'
    assert_tag :tag => "fb:request-form"
    assert_tag :tag => "fb:multi-friend-selector"
    assert assigns(:exclude_ids)
  end
  
  def test_facebook_user_set
    new_user_sig = "0010100111"
    assert_difference 'User.count', +1, "user should create from facebook" do
      facebook_get :index, :fb_sig_user => new_user_sig
      assert_response :success
      assert assigns(:current_user)
    end
    
    existing_user_id = assigns(:current_user).facebook_id
    assert_no_difference 'User.count', "existing user should have been found facebook" do
      facebook_get :index, :fb_sig_user => existing_user_id
    end
  end
end