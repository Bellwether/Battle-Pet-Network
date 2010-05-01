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
end