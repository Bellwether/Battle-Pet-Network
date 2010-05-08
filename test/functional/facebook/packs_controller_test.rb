require 'test_helper'

class Facebook::PacksControllerTest < ActionController::TestCase     
  include Facebooker::Rails::TestHelpers
  
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
    user = users(:two)
    pet = user.pet
    pet.belongings.create(:item_id => items(:fiberboard_pillar).id, :source => 'purchased')
    
    mock_user_facebooking(user.facebook_id)
    facebook_get :new, :fb_sig_user => user.facebook_id
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
end