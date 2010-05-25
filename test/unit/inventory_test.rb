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
end