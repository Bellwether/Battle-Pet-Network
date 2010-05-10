require 'test_helper'

class Facebook::HuntsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:two)
    @pet = @user.pet
    @sentient = sentients(:leper_rat)
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
end