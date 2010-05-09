require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = items(:cat_grass)
    @pet = pets(:persian)
  end
  
  def test_purchase_for
    assert_difference '@item.stock', -1 do
    assert_difference '@pet.kibble', -@item.cost do
      assert_difference '@pet.belongings.count', +1 do
        belonging = @item.purchase_for!(@pet)
        assert_equal 'purchased', belonging.source
      end    
    end
    end
    @pet.update_attribute(:kibble, 0)
    purchase = @item.purchase_for!(@pet)
    assert purchase.errors.on_base.include?("too expensive")
    @item.update_attribute(:stock, 0)
    purchase = @item.purchase_for!(@pet)
    assert purchase.errors.on_base.include?("out of stock")
  end
end