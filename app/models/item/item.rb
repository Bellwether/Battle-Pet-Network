class Item < ActiveRecord::Base
  validates_inclusion_of :item_type, :in => %w(Food Kibble Toy Collar Claws Sensors Ornament Mantle Charm Standard)
  
  has_many :spoils
  has_many :inventories
  has_many :belongings
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end    
end