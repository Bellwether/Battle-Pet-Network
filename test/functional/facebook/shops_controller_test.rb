require 'test_helper'

class Facebook::ShopsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @shop = shops(:first)
    @user = users(:three)
    @pet = @user.pet
    @params = {:pet_id => @pet.id, :name => 'test shop', :specialty => 'Food'}
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

  def test_get_shop
    fbid = users(:three).facebook_id
    mock_user_facebooking(fbid)
    facebook_get :show, :id => @shop.id, :fb_sig_user => fbid
    assert_response :success
    assert_template 'show'
    assert assigns(:shop)
    assert assigns(:inventory)
    assert_tag :tag => "table", :attributes => { :class => "shopkeeper" }
    assert_tag :tag => "span", :attributes => { :class => "shopping-button" }
  end

  def test_get_new
    user = users(:three)
    pet = user.pet

    mock_user_facebooking(user.facebook_id)
    facebook_get :new, :fb_sig_user => user.facebook_id
    assert_response :success
    assert_template 'new'
    assert assigns(:shop)
    assert_tag :tag => "form", :descendant => { 
      :tag => "table", :attributes => { :class => "form" },
      :tag => "table", :attributes => { :id => "inventory-picker" },
      :tag => "tr", :attributes => { :class => "inventory-item" },
      :tag => "select", :attributes => { :name => "shop[:specialty]" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end
  
  def test_create
    mock_user_facebooking(@user.facebook_id)
    assert_difference 'Shop.count', +1 do
      facebook_post :create, :shop => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert flash[:notice]
      assert !assigns(:shop).blank?
    end
  end
  
  def test_fail_create
    @params.delete(:name)
    mock_user_facebooking(@user.facebook_id)
    assert_no_difference 'Shop.count' do
      facebook_post :create, :shop => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:shop).blank?
    end
  end
  
  def test_edit
    fbid = @shop.pet.user.facebook_id
    mock_user_facebooking(fbid)
    facebook_get :edit, :fb_sig_user => fbid
    assert_response :success
    assert_template 'edit'
    assert !assigns(:shop).blank?
    assert !assigns(:inventory).blank?
    assert !assigns(:belongings).blank?
    assert_tag :tag => "form", :attributes => { :id => 'shop-form' }
    assert_tag :tag => "table", :attributes => { :class => 'item dotbox' }
  end
end