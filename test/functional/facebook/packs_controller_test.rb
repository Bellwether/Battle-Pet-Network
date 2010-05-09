require 'test_helper'

class Facebook::PacksControllerTest < ActionController::TestCase     
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = users(:three)
    @pet = @user.pet
    @standard = items(:fiberboard_pillar)
    @params = {:founder_id => @pet.id, :name => 'test pack', :standard_id => @standard.id}
  end
  
  def test_get_pack
    mock_user_facebooking
    facebook_get :show, :id => packs(:alpha).id, :fb_sig_user => nil
    assert_response :success
    assert_template 'show'
    assert assigns(:pack)
    assert_tag :tag => "div", :attributes => { :id => "spoils" }
    assert_tag :tag => "td", :attributes => { :class => "pack-member" }
    assert_no_tag :tag => "span", :attributes => { :id => "challenge-button" }
    assert_no_tag :tag => "span", :attributes => { :id => "membership-button" }
  end

  def test_get_pack_with_pet
    mock_user_facebooking(users(:three).facebook_id)
    facebook_get :show, :id => packs(:alpha).id, :fb_sig_user => users(:three).facebook_id
    assert_response :success
    assert_template 'show'
    assert assigns(:pack)
    assert_tag :tag => "div", :attributes => { :id => "spoils" }
    assert_tag :tag => "td", :attributes => { :class => "pack-member" }
    assert_tag :tag => "span", :attributes => { :id => "challenge-button" }
    assert_tag :tag => "span", :attributes => { :id => "membership-button" }
  end
  
  def test_get_new_pack
    pet = @user.pet
    pet.belongings.create(:item_id => items(:fiberboard_pillar).id, :source => 'purchased')
    
    mock_user_facebooking(@user.facebook_id)
    facebook_get :new, :fb_sig_user => @user.facebook_id
    assert_response :success
    assert_template 'new'
    assert assigns(:pack)
    assert assigns(:standards)
    assert_tag :tag => "form", :descendant => { 
      :tag => "input", :attributes => { :name => "pack[standard_id]", :type => "radio" },  
      :tag => "table", :attributes => { :id => "item-picker" },
      :tag => "ul", :attributes => { :class => "items" },
      :tag => "input", :attributes => { :type => "submit" }
    }
  end

  def test_create
    mock_user_facebooking(@user.facebook_id)
    @pet.update_attribute(:kibble, AppConfig.packs.founding_fee)
    assert_difference 'Pack.count', +1 do
      facebook_post :create, :pack => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:pack).blank?
    end    
    assert flash[:notice]
    assert_equal assigns(:pack).id, @pet.reload.pack_id
  end

  def test_fail_create
    mock_user_facebooking(@user.facebook_id)
    @pet.update_attribute(:kibble, AppConfig.packs.founding_fee - 1)
    assert_no_difference 'Pack.count' do
      facebook_post :create, :pack => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert !assigns(:pack).blank?
    end    
    assert flash[:error]
  end
end