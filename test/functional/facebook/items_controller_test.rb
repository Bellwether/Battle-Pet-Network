require 'test_helper'

class Facebook::ItemsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def test_index
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert_tag :tag => "table", :attributes => { :class => "item-store" }
    assert_tag :tag => "span", :attributes => { :class => "shopping-button" }
  end
  
  def test_store
    mock_user_facebooking
    facebook_get :store, :fb_sig_user => nil, :id => 'Food'
    assert_response :success
    assert_template 'store'
    assert !assigns(:items).blank?
    assert_tag :tag => "h3", :attributes => { :id => "food-store-title" }
    assert_no_tag :tag => "span", :attributes => { :class => "shopping-button" }
  end
  
  def test_store_with_pet
    fbid = users(:three).facebook_id
    mock_user_facebooking(fbid)
    facebook_get :store, :fb_sig_user => fbid, :id => 'Food'
    assert_response :success
    assert_template 'store'
    assert !assigns(:items).blank?
    assert_tag :tag => "h3", :attributes => { :id => "food-store-title" }
    assert_tag :tag => "span", :attributes => { :class => "shopping-button" }
  end
end