require 'test_helper'

class HunterTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
  end
  
  def test_validates_pet_strategy
    valid_strategy = Strategy.new(:combatant => @pet)
    invalid_strategy = Strategy.new(:combatant => pets(:persian))
    hunter = Hunter.new(:pet_id => @pet.id)
    hunter.strategy = valid_strategy
    hunter.save
    assert !hunter.errors.on(:strategy_id).include?("unknown strategy")
    hunter.strategy = invalid_strategy
    hunter.save
    assert hunter.errors.on(:strategy_id).include?("unknown strategy")
  end
end