require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @shop = shops(:first)
    @params = {:pet_id => @pet.id, :name => 'test shop', :specialty => 'Food'}
  end
  
  def test_test_validates_max_inventory
    fill_items = (@shop.max_inventory - @shop.inventories.count)
    fill_items.times do
      @shop.inventories.create(:item_id => items(:cat_grass).id, :cost => 10)
    end
    @shop.inventories.create(:item_id => items(:cat_grass).id, :cost => 10)
    assert !@shop.valid?
    puts  @shop.errors.on_base
    assert @shop.errors.on_base.include?("inventory limit reached")
  end
end