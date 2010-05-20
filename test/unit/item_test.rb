require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = items(:cat_grass)
    @treat = items(:cheezburger)
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
  
  def test_eat_food
    @pet.update_attributes(:current_health => 1, :current_endurance => 1)
    @item.eat!(@pet)
    assert_equal @pet.health, @pet.current_health
    assert_equal @item.power + 1, @pet.current_endurance
    @pet.update_attributes(:current_health => @pet.health - 1, :current_endurance => @pet.endurance - 1)
    @item.eat!(@pet)
    assert_equal @pet.health, @pet.current_health
    assert_equal @pet.endurance, @pet.current_endurance
  end
  
  def test_eat_treat
    @pet.update_attributes(:current_health => 1)
    @treat.eat!(@pet)
    assert_equal @pet.health + @treat.power, @pet.current_health
    @pet.update_attributes(:current_health => @pet.health + 1)
    @treat.eat!(@pet)
    assert_equal @pet.health + 1 + @treat.power, @pet.current_health
  end
end