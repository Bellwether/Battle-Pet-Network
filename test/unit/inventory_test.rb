require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  def setup
    @shop = shops(:first)
    @belonging = belongings(:four_grass)
  end
  
  def test_intialize_from_belonging
    inventory = Inventory.new(:belonging_id => @belonging.id, :shop_id => @shop.id)
    assert_equal @belonging.item_id, inventory.item_id
  end
  
  def test_validates_belonging
    @belonging = belongings(:three_grass)
    inventory = Inventory.new(:belonging_id => @belonging.id, :shop_id => @shop.id)
    inventory.save
    assert_equal "shop owner isn't holding belonging", inventory.errors.on(:item_id)
  end
  
  def test_remove_belonging
    pet = @shop.pet
    assert_difference ['Belonging.count'], -1 do
      inventory = Inventory.create!(:belonging_id => @belonging.id, :shop_id => @shop.id, :cost => 10)      
    end
  end
  
  def test_unstock
    pet = @shop.pet
    inventory = @shop.inventories.first
    assert_difference ['pet.belongings.count'], +1 do
      assert_difference ['@shop.inventories.count'], -1 do
        inventory.unstock!
      end
    end
  end
end