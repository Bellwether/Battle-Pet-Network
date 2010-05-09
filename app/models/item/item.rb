class Item < ActiveRecord::Base
  TYPES = ['Food', 'Kibble', 'Toy', 'Collar', 'Claws', 'Sensors', 'Ornament', 'Mantle', 'Charm', 'Standard']
  
  validates_inclusion_of :item_type, :in => TYPES
  validates_numericality_of :cost, :greater_than_or_equal_to => 0
  validates_numericality_of :stock, :greater_than_or_equal_to => 0
  validates_numericality_of :restock_rate, :greater_than_or_equal_to => 0
  validates_numericality_of :stock_cap, :greater_than_or_equal_to => 0
  
  has_many :spoils
  has_many :inventories
  has_many :belongings

  named_scope :in_stock, :conditions => 'stock > 0'
  named_scope :marketable, :conditions => 'cost > 0'  
  named_scope :type_is, lambda { |item_type| 
    { :conditions => ["item_type = ?", item_type] }
  }
  
  cattr_reader :per_page
  @@per_page = 20
  
  def slug
    name.downcase.gsub(/\s/,'-')
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