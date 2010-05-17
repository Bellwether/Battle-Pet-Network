require 'test_helper'

class HuntTest < ActiveSupport::TestCase
  def setup
    @sentient = sentients(:gila_monstrosity)
    @pet = pets(:persian)
  end
  
  def test_required_rank
    assert_operator @pet.level_rank_count, "<", @sentient.required_rank
    hunt = @sentient.hunts.create(:hunters_attributes => { "0" => {:pet_id => @pet.id }})
    assert_equal "required level too high", hunt.errors.on(:sentient_id)
  end
  
  def test_hunter
    hunt = hunts(:rat_hunt)
    assert_not_nil hunt.hunters
    assert_not_nil hunt.hunter
    assert_not_nil hunt.hunter.pet
  end
  
  def test_set_outcome
    mock_combat
    hunt = @sentient.hunts.build(:hunters_attributes => { "0" => {:pet_id => @pet.id }})
    hunt.attacker.current_health = 0
    hunt.defender.current_health = 0
    hunt.set_outcome
    assert_equal "deadlocked", hunt.hunter.outcome
    hunt.attacker.current_health = 10
    hunt.set_outcome
    assert_equal "won", hunt.hunter.outcome
    hunt.attacker.current_health = 0
    hunt.defender.current_health = 10
    hunt.set_outcome
    assert_equal "lost", hunt.hunter.outcome
    assert_equal "ended", hunt.status
  end
  
  def test_award
    mock_combat
    hunt = @sentient.hunts.build(:hunters_attributes => { "0" => {:pet_id => @pet.id }})
    hunt.sentient.current_health = 0
    hunt.set_outcome
    assert_difference ['hunt.hunter.pet.kibble'], +hunt.sentient.kibble do
      hunt.award!
    end
    hunt.sentient.current_health = 10
    hunt.hunter.pet.current_health = 0
    hunt.set_outcome
    assert_no_difference ['hunt.hunter.pet.kibble'] do
      hunt.award!
    end
  end
end