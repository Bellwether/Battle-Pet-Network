class Inventory < ActiveRecord::Base
  belongs_to :shop, :validate => true, :counter_cache => true
  belongs_to :item
  
  validates_presence_of :item_id, :shop_id, :cost
  validates_numericality_of :cost, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 1000000
  
  attr_accessor :belonging_id
    
  cattr_reader :per_page
  @@per_page = 12
  
  validate :validates_belonging
  
  def validates_belonging
    return if belonging_id.blank? || shop_id.blank?
    errors.add(:item_id, "shop owner isn't holding belonging") if shop.pet.belongings.holding.find_by_id(belonging_id).blank?
  end
  
  def after_initialize(*args)
    if item_id.blank? && !belonging_id.blank?
      self.item_id = Belonging.find(belonging_id).item_id
    end
  end
end