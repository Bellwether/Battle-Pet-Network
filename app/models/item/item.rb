class Item < ActiveRecord::Base
  TYPES = ['Food', 'Kibble', 'Toy', 'Collar', 'Claws', 'Sensors', 'Ornament', 'Mantle', 'Charm', 'Standard']
  
  validates_inclusion_of :item_type, :in => TYPES
  
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
end