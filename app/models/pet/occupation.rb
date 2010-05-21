class Occupation < ActiveRecord::Base
  has_many :pets
  
  named_scope :scavenging, :conditions => "name LIKE 'Scavenging'", :limit => 1  
  
  validates_inclusion_of :status, :in => ['Prowling','Scavenging','Human Taming','Shopkeeping']
    
  def slug
    name.downcase.gsub(/\s/,'-')
  end
  
  def pet_doing?(pet)
    pet.occupation_id == self.id
  end

  def pet_can?(pet)
    cost > 0 && pet.current_endurance >= cost
  end
  
  def do_for_pet!(pet,subject=nil)
    return false unless pet_can?(pet)
    success = false
    case name
      when 'Human Taming'
        success = tame_human(pet,subject)
        exhaust pet
      when 'Scavenging'  
        success = scavenge_item(pet,subject)
        exhaust pet
    end
    return success
  end
  
  def perform_for_pet(pet)
    case name
      when 'Human Taming'
      when 'Scavenging'
    end
  end
  
  def tame_human(pet,human=nil)
    success = Human.finds_human?(pet)
    human = Human.find_random_human(pet,human) if success
    success = Tame.pet_tames_human?(pet,human) if success
    success = pet.tames.create(:human => human, :status => 'kenneled') if success
    return success
  end
  
  def scavenge_item(pet,item=nil)
    success = Item.scavenges?(pet)
    item = Item.find_random_item(pet,item).first if success
    success = pet.belongings.create(:item => item, :source => 'scavenged') if success
    return success
  end
  
  def exhaust(pet)
    pet.update_attribute(:current_endurance, [pet.current_endurance - cost, 0].max)
  end
end