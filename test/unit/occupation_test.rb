require 'test_helper'

class OccupationTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @human = humans(:oscar)
    @taming = occupations(:taming)
  end
  
  def test_tame_human
    flexmock(Human).should_receive(:finds_human?).and_return(true)
    flexmock(Human).should_receive(:find_random_human).and_return(@human)
    flexmock(Tame).should_receive(:pet_tames_human?).and_return(true)
    assert_difference '@pet.tames.count', +1 do
      @taming.tame_human(@pet)
    end
  end
end