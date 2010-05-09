require 'test_helper'

class Facebook::ShopsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @shop = shops(:first)
  end

  def test_index
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil
    assert_response :success
    assert_template 'index'
    assert !assigns(:shops).blank?
    assert !assigns(:shop_filter_types).blank?
    assert !assigns(:filters).blank?
    assert_tag :tag => "table", :attributes => { :id => "shops" }, :descendant => { 
      :tag => "label", :attributes => { :class => "shop" }
    }
  end
  
  def test_index_search
    phrase = 'grass'
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil, :search => phrase
    assert !assigns(:shops).blank?
    assigns(:shops).each do |shop|
      assert shop.inventories.map(&:item).map(&:name).join(' ').downcase.include?(phrase.downcase)
    end
  end
  
  def test_index_filter
    filter = 'Food'
    mock_user_facebooking
    facebook_get :index, :fb_sig_user => nil, :filter => filter
    assert !assigns(:shops).blank?
    assigns(:shops).each do |shop|
      assert shop.inventories.map(&:item).map(&:item_type).join(' ').downcase.include?(filter.downcase)
    end
  end
end