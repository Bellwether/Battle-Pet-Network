require 'test_helper'

class StrategyTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @new_strategy = @pet.strategies.build
    @maneuver = @new_strategy.maneuvers.build(:action => actions(:scratch))
  end
  
  def test_set_name
    assert_nil @new_strategy.name
    @new_strategy.save
    assert_not_nil @new_strategy.name
  end
end