require 'test_helper'

class Facebook::LobbyControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
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
    facebook_get :invite, :fb_sig_user => users(:one).facebook_id.to_s
    assert_response :success
    assert_template 'invite'
    assert_tag :tag => "fb:request-form"
    assert_tag :tag => "fb:multi-friend-selector"
    assert assigns(:exclude_ids)
  end
end