require 'test_helper'

class Facebook::LobbyControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def test_should_get_index
    facebook_get :index
    assert_response :success
    assert_template 'index'
  end
end