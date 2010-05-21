require 'test_helper'

class TameTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @tamed = pets(:siamese).tames.kenneled.first
    @human = humans(:sarah)
  end
  
  def test_validates_exclusivity
    tame = @pet.tames.new(:human_id => @tamed.human.id)
    tame.save
    assert tame.errors.on(:human_id).include?("human already tamed")
  end
  
  def test_enslaves
    @pet.tames.kenneled.enslave(@tamed.id)
    assert_equal 'enslaved', @tamed.reload.status
  end
  
  def test_releases
    release_award = @tamed.human.power * AppConfig.humans.release_multiplier
    assert_difference '@pet.reload.kibble', +release_award do 
      assert_difference ['@pet.tames.count','Tame.count'], -1 do
        @pet.tames.kenneled.release(@tamed.id)
      end    
    end
    assert_nil Tame.find_by_id(@tamed.id)
  end
  
  def pet_tames_human
    chance = @pet.affection.to_f + @pet.affection_bonus.to_f
    AppConfig.occupations.tame_human_chance_divisor = chance / 1000
    assert Tame.pet_tames_human?(@pet,@human)
    AppConfig.occupations.tame_human_chance_divisor = chance * 1000
    assert !Tame.pet_tames_human?(@pet,@human)
  end
end