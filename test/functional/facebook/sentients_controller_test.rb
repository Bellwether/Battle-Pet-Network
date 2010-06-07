require 'test_helper'

class Facebook::SentientsControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:two)
    @sentient = sentients(:leper_rat)
  end
  
  def test_index_without_pet
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert !assigns(:sentients).blank?
    assert_tag :tag => "table", :attributes => { :class => "sentients" }
    assert_no_tag :tag => "span", :attributes => { :class => "right hunt-button" }
  end

  def test_index_with_pet
    mock_user_facebooking(@user.facebook_id)
    facebook_get :index, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'index'
    assert !assigns(:sentients).blank?
    assert_tag :tag => "span", :attributes => { :class => "right hunt-button" }
  end
  
  def test_get_sentient
    facebook_get :show, :id => @sentient.id, :fb_sig_user => nil
    assert_response :success
    assert_template 'show'
    assert !assigns(:sentient).blank?
    assert !assigns(:hunts).blank?
    assert !assigns(:tactics).blank?
    assert_tag :tag => "ul", :attributes => { :class => "tactics" }, :descendant => {
      :tag => "li", :attributes => { :class => "tactic" }
    }
  end
end