require 'test_helper'

class Facebook::PacksControllerTest < ActionController::TestCase     
  include Facebooker::Rails::TestHelpers
  
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