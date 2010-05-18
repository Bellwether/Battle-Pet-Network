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
  
  def test_index
    pet = pets(:persian)
    user = pet.user
    mock_user_facebooking(user.facebook_id)
    facebook_get :index, :fb_sig_user => user.facebook_id
    assert_template 'index'
    assert !assigns(:challenges).blank?
    assert !assigns(:issued).blank?
    assert !assigns(:resolved).blank?
    assert_tag :tag => "ul", :attributes => { :id => 'issued-challenges'}, :descendant => {
      :tag => "a"
    }
    assert_tag :tag => "table", :attributes => {:class => 'challenge'}, :descendant => {
      :tag => "span", :attributes => { :class => "right button" },  
      :tag => "span", :attributes => { :class => "left button" }
    }
  end
  
  def test_show
    mock_user_facebooking(@user.facebook_id)
    facebook_get :show, :fb_sig_user => @user.facebook_id, :id => challenges(:siamese_burmese_resolved).id
    assert_response :success
    assert_template 'show'
    assert !assigns(:challenge).blank?
    assert !assigns(:pet).blank?
    assert !assigns(:opponent).blank?
    assert !assigns(:history).blank?
    assert_tag :tag => "ul", :attributes => { :class => 'battle-records'}, :descendant => {
      :tag => "li", :attributes => { :class => "battle" }
    }
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
      :tag => "table", :attributes => { :class => "battle-gear" },
      :tag => "td", :attributes => { :class => "battle-gear" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end
  
  def test_create
    Challenge.destroy_all
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
    Challenge.destroy_all
    assert_no_difference ['Challenge.count','Strategy.count'] do
      @params = {}
      facebook_post :create, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id, :challenge => @params
      assert_response :success
      assert !assigns(:challenge).blank?
      assert !assigns(:pet).blank?
    end    
    assert flash[:error]
  end
  
  def test_edit
    challenge = challenges(:siamese_persian_issued)
    pet = challenge.defender
    mock_user_facebooking(pet.user.facebook_id)
    facebook_get :edit, :fb_sig_user => pet.user.facebook_id, :id => challenge.id
    assert_response :success
    assert_template 'edit'
    assert !assigns(:challenge).blank?
    assert !assigns(:pet).blank?
    assert_tag :tag => "form", :descendant => { 
      :tag => "table", :attributes => { :class => "comparison-table" },
      :tag => "table", :attributes => { :class => "battle-gear" },
      :tag => "td", :attributes => { :class => "battle-gear" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end
  
  def test_create_parameter_injection
    @exploiter = pets(:burmese)
    @params[:attacker_strategy_attributes][:combatant_id] = @exploiter.id
    facebook_post :create, :fb_sig_user => @user.facebook_id, :pet_id => @defender.id, :challenge => @params
    assert !assigns(:challenge).blank?
    assert_equal @attacker.id, assigns(:challenge).attacker_strategy.combatant_id
  end
end