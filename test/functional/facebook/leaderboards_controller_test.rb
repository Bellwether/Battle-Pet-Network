require 'test_helper'

class Facebook::LeaderboardsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
  end
  
  def test_index
    mock_user_facebooking
    facebook_get :index
    assert_response :success
    assert_template 'index'
    assert !assigns(:indefatigable).blank?
    assert !assigns(:overlords).blank?
    assert !assigns(:strongest).blank?
    assert_tag :tag => "table", :attributes => {:class => 'leaderboard'}, :descendant => {
      :tag => "tr", :attributes => { :class => "ranking" }
    }
  end  
end