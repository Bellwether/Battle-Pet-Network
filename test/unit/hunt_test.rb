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
end