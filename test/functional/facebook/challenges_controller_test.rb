require 'test_helper'

class Facebook::ChallengesControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @attacker = pets(:siamese)
    @defender = pets(:persian)
    @user = @attacker.user
    @params = {:attacker_strategy_attributes => {
                :maneuvers_attributes => { "0" => {:action_id => actions(:scratch).id}} 
              }}
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
      :tag => "td", :attributes => { :class => "battle-gear" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end

  def test_create
    mock_user_facebooking(@user.facebook_id)   
    assert_difference ['Challenge.count','Strategy.count'], +1 do
      facebook_post :create, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id, :challenge => @params
      assert_response :success
      assert !assigns(:challenge).blank?
      assert !assigns(:pet).blank?
    end    
    assert flash[:notice]
  end

  def test_fail_create
    mock_user_facebooking(@user.facebook_id)   
    assert_no_difference ['Challenge.count','Strategy.count'] do
      @params[:attacker_strategy_attributes][:maneuvers_attributes] = {}
      facebook_post :create, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id, :challenge => @params
      assert_response :success
      assert !assigns(:challenge).blank?
      assert !assigns(:pet).blank?
    end    
    assert flash[:error]
  end
  
  def test_create_parameter_injection
    @exploiter = pets(:burmese)
    @params[:attacker_strategy_attributes][:combatant_id] = @exploiter.id
    facebook_post :create, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id, :challenge => @params
    assert !assigns(:challenge).blank?
    assert_equal @attacker.id, assigns(:challenge).attacker_strategy.combatant_id
  end
end