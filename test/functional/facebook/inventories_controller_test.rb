require 'test_helper'

class Facebook::InventoriesControllerTest  < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @shop = shops(:first)
    @pet = @shop.pet
    @user = @pet.user           
    @belonging = belongings(:four_grass)
    @params = {:belonging_id => @belonging.id, :cost => 15}
    mock_user_facebooking(@user.facebook_id)
  end
  
  def test_create
    assert_difference ['Inventory.count','@shop.inventories.count'], +1 do
      facebook_post :create, :inventory => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert flash[:notice]
      assert !assigns(:inventory).blank?
    end
  end
  
  def test_fail_create
    @params = {:belonging_id => nil}
    assert_no_difference ['Inventory.count','@shop.inventories.count'] do
      facebook_post :create, :inventory => @params, :fb_sig_user => @user.facebook_id
      assert_response :success
      assert flash[:alert]
    end
  end
end