require 'test_helper'

class StrategyTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @new_strategy = @pet.strategies.build
    @maneuver = @new_strategy.maneuvers.build(:action => actions(:scratch))
    @favorite_strategy = @pet.strategies.build
    @favorite_strategy.maneuvers.build(:action => @pet.favorite_action)
    @favorite_strategy.maneuvers.build(:action => @pet.breed.favorite_action)
  end
  
  def test_set_name
    assert_nil @new_strategy.name
    @new_strategy.save
    assert_not_nil @new_strategy.name
  end
  
  def test_average_power
    strategy = @pet.strategies.build
    average = strategy.average_power
    assert_equal 0, average
    actions = [actions(:scratch),actions(:flank),actions(:claw)]
    actions.each do |a|
      strategy.maneuvers.build(:action => a)
      average = average + a.power
    end
    assert_operator average, ">", 0
    assert_equal (average / strategy.maneuvers.size), strategy.average_power
  end
  
  def test_favorite_action_experience_bonus
    assert_equal 0, strategies(:leper_rat_strategy).favorite_action_experience_bonus
    expected = (AppConfig.experience.favorite_action_bonus * @favorite_strategy.maneuvers.size)
    assert_operator @favorite_strategy.favorite_action_experience_bonus, ">", 0
    assert_equal expected, @favorite_strategy.favorite_action_experience_bonus
  end
end