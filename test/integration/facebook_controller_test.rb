require 'test_helper'

class FacebookControllerTest < ActionController::IntegrationTest
  def setup
    mock_user_facebooking
  end
  
  def test_facebook_layout  
    get facebook_root_path, :fb_sig => Authlogic::Random.friendly_token
    assert_response :success
    assert_tag :tag => "fb:tabs"
    assert_tag :tag => "fb:bookmark"
    assert_tag :tag => "fb:fan"
  end
end