require 'test_helper'

class Facebook::HuntsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:two)
    @pet = @user.pet
    @sentient = sentients(:leper_rat)
    @new_strategy_params = {:maneuvers_attributes => { "0" => {:rank => 1, :action_id => actions(:scratch).id}}}
    @params = {:sentient_id => @sentient.id, :hunters_attributes => {"0" => {:pet_id => @pet.id, :strategy_attributes => @new_strategy_params}} }
  end

  def test_get_new
    mock_user_facebooking(@user.facebook_id)
    facebook_get :new, :fb_sig_user => @user.facebook_id, :sentient_id => @sentient.id
    assert_response :success
    assert_template 'new'
    assert !assigns(:sentient).blank?
    assert !assigns(:hunt).blank?
    assert !assigns(:hunt).hunters.blank?
    assert assigns(:hunt).hunters.map(&:pet_id).include?(@pet.id)
    assert_tag :tag => "form", :descendant => { 
      :tag => "table", :attributes => { :class => "comparison-table" },
      :tag => "ul", :attributes => { :class => "tactics" },
      :tag => "li", :attributes => { :class => "tactic" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end

  def test_create
    mock_user_facebooking(@user.facebook_id)   
    assert_difference ['Hunt.count','Hunter.count','Strategy.count'], +1 do
      facebook_post :create, :sentient_id => @sentient.id, :hunt => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:hunt).blank?
      assert !assigns(:hunt).hunters.blank?
      assert assigns(:hunt).hunters.map(&:pet_id).include?(@pet.id)
    end    
    assert flash[:notice]
  end

  def test_fail_create
    mock_user_facebooking(@user.facebook_id)   
    assert_no_difference ['Hunt.count','Hunter.count','Strategy.count'] do
      @params = {}
      facebook_post :create, :sentient_id => @sentient.id, :hunt => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:hunt).blank?
    end    
    assert flash[:error]
  end
end