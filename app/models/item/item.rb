class Item < ActiveRecord::Base
  TYPES = ['Food', 'Treat', 'Kibble', 'Toy', 'Collar', 'Weapon', 'Sensor', 'Ornament', 'Mantle', 'Charm', 'Standard']
  BATTLE_TYPES = ['Collar', 'Weapon', 'Sensor', 'Mantle']
  FOODSTUFFS = ['Food', 'Treat']  
  
  validates_inclusion_of :item_type, :in => TYPES
  validates_numericality_of :cost, :greater_than_or_equal_to => 0
  validates_numericality_of :stock, :greater_than_or_equal_to => 0
  validates_numericality_of :restock_rate, :greater_than_or_equal_to => 0
  validates_numericality_of :stock_cap, :greater_than_or_equal_to => 0
  
  belongs_to :species
  
  has_many :spoils
  has_many :inventories
  has_many :belongings

  named_scope :kibble, :conditions => "item_type = 'Kibble'"
  named_scope :premium, :conditions => {:premium => true}
  named_scope :in_stock, :conditions => 'stock > 0'
  named_scope :marketable, :conditions => 'cost > 0'  
  named_scope :type_is, lambda { |item_type| 
    { :conditions => ["item_type = ?", item_type] }
  }
  named_scope :random, :conditions => 'rarity > 0', :order => "rarity * RAND() DESC"
  named_scope :random_for_pet, lambda { |pet| 
    { :conditions => ["rarity > 0 AND required_rank <= ?", pet.level_rank_count], :order => "rarity * RAND() DESC" }
  }
    
  cattr_reader :per_page
  @@per_page = 20
  
  class << self
    def find_random_item(pet=nil,item=nil)
      return pet.blank? ? Item.random : Item.random_for_pet(pet)
    end
    
    def scavenges?(pet)
      div = AppConfig.occupations.scavenge_chance_divisor.to_f
      chance = (pet.intelligence.to_f + pet.intelligence_bonus.to_f) / div
      val = 1 + rand(100)
      return val <= chance
    end    
  end  
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end 
  
  def bonus
    ""
  end
  
  def gear?
    Item::BATTLE_TYPES.include?(item_type)
  end
  
  def food?
    Item::FOODSTUFFS.include?(item_type)
  end

  def practice?
    item_type.downcase == "toy"
  end
  
  def currency?
    item_type.downcase == "kibble"
  end
  
  def eat!(pet)
    return false unless food?
    case item_type
      when 'Food'
        pet.current_endurance = [pet.current_endurance + power, pet.endurance].min
        pet.current_health = pet.health
      when 'Treat'  
        pet.current_health = [pet.health, pet.current_health].max + power
    end    
    return pet.save
  end
  
  def practice!(pet)
    return false unless practice?
    return pet.award_experience!(power)
  end
  
  def purchase_for!(pet)
    belonging = belongings.build(:pet_id => pet.id, :source => 'purchased')
    belonging.errors.add_to_base("out of stock") if stock < 1
    belonging.errors.add_to_base("too expensive") if cost > pet.kibble
    if belonging.errors.empty? && belonging.save
      pet.update_attribute(:kibble, pet.kibble - cost)
      self.update_attribute(:stock, stock - 1)
    end
    return belonging
  end  
end