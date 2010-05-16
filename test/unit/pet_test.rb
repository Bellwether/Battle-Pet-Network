require 'test_helper'

class PetTest < ActiveSupport::TestCase
  def setup
    mock_user_facebooking
    
    @user = users(:one)
    @new_pet = Pet.new(:name => 'lilly', :breed_id => breeds(:persian).id, :user_id => @user.id)
    @pet = pets(:siamese)
  end
  
  def test_set_slug
    assert @new_pet.save
    assert_not_nil @new_pet.slug
  end

  def test_set_occupation
    assert @new_pet.save
    assert_not_nil @new_pet.reload.occupation
  end
  
  def test_set_user
    assert @new_pet.save
    assert_equal @new_pet.id, @user.reload.pet_id
  end

  def test_populate_from_breed
    breed = breeds(:persian)
    @new_pet.populate_from_breed

    assert_equal breed.health, @new_pet.health
    assert_equal breed.endurance, @new_pet.endurance
    assert_equal breed.power, @new_pet.power
    assert_equal breed.intelligence, @new_pet.intelligence
    assert_equal breed.fortitude, @new_pet.fortitude
    assert_equal breed.affection, @new_pet.affection
    
    assert_equal @new_pet.health, @new_pet.current_health
    assert_equal @new_pet.endurance, @new_pet.current_endurance
  end
  
  def test_update_occupation
    pet = pets(:siamese)
    occupation = occupations(:taming)
    pet.update_occupation!(occupation.id)
    assert_equal occupation.id, pet.reload.occupation_id
  end
  
  def test_is_prowling
    taming = occupations(:taming)
    prowling = occupations(:prowling)
    @pet.update_attribute(:occupation_id,prowling.id)
    assert @pet.reload.prowling?
    @pet.update_attribute(:occupation_id,taming.id)
    assert !@pet.reload.prowling?
  end
  
  def test_set_level
    assert @new_pet.save
    assert_equal 1, @new_pet.level_rank_count
    assert_not_nil @new_pet.level_id
  end
  
  def test_award_experience
    exp = 10
    assert_difference 'Pet.find(@pet).experience', +exp do
      @pet.award_experience!(exp)
    end
  end
end