class Occupation < ActiveRecord::Base
  has_many :pets
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end
  
  def pet_doing?(pet)
    pet.occupation_id == self.id
  end
  
  def pet_can_do?(pet)
    true
  end

  def pet_can?(pet)
    cost > 0 && pet.current_endurance >= cost
  end
end