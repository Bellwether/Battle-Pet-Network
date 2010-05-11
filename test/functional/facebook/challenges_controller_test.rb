require 'test_helper'

class Facebook::ChallengesControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @attacker = pets(:siamese)
    @defender = pets(:persian)
    @user = @attacker.user
  end
  
  def test_get_new
    mock_user_facebooking(@user.facebook_id)
    facebook_get :new, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id
    assert_response :success
    assert_template 'new'
    assert !assigns(:challenge).blank?
    assert !assigns(:pet).blank?
    assert_tag :tag => "form", :descendant => { 
      :tag => "table", :attributes => { :class => "comparison-table" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end
end