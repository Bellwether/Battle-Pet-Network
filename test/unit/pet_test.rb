require 'test_helper'

class PetTest < ActiveSupport::TestCase
  def setup
    mock_user_facebooking
  end
  
  def test_set_slug
    user = users(:one)
    pet = Pet.new(:name => 'lilly', :breed_id => breeds(:persian).id, :user_id => user.id)
    assert pet.save
    assert_not_nil pet.slug
  end
  
  def test_set_user
    user = users(:one)
    pet = Pet.new(:name => 'lilly', :breed_id => breeds(:persian).id, :user_id => user.id)
    assert pet.save
    assert_equal pet.id, user.reload.pet_id
  end

  def test_populate_from_breed
    breed = breeds(:persian)
    pet = Pet.new(:name => 'lilly', :breed_id => breed.id)
    pet.populate_from_breed

    assert_equal breed.health, pet.health
    assert_equal breed.endurance, pet.endurance
    assert_equal breed.power, pet.power
    assert_equal breed.intelligence, pet.intelligence
    assert_equal breed.fortitude, pet.fortitude
    assert_equal breed.affection, pet.affection
    
    assert_equal pet.health, pet.current_health
    assert_equal pet.endurance, pet.current_endurance
  end
end