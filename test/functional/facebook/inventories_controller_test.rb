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
  
  def test_update
    inventory = @shop.inventories.first
    cost = inventory.cost + 10
    assert_difference 'inventory.reload.cost', +10 do
      facebook_put :update, :inventory => {:cost => cost}, :fb_sig_user => @user.facebook_id, :id => inventory.id
      assert_response :success
      assert flash[:notice]
    end
  end

  def test_fail_update
    inventory = @shop.inventories.first
    cost = -1
    assert_no_difference 'inventory.reload.cost' do
      facebook_put :update, :inventory => {:cost => cost}, :fb_sig_user => @user.facebook_id, :id => inventory.id
      assert_response :success
      assert flash[:error]
    end
  end
  
  def test_destroy
    inventory = @shop.inventories.first
    assert_difference ['Inventory.count','@shop.inventories.count'], -1 do
      facebook_delete :destroy, :inventory => @params, :fb_sig_user => @user.facebook_id, :id => inventory.id
      assert_response :success
      assert flash[:notice]
    end
  end
end