class Belonging < ActiveRecord::Base
  belongs_to :pet
  belongs_to :item
  
  validates_presence_of :item_id, :pet_id, :source, :status
  validates_inclusion_of :status, :in => %w(active holding expended)
  validates_inclusion_of :source, :in => %w(scavenged purchased gift award)
  
  validate :validates_exclusivity
  after_create :apply
  after_validation :deactivate_other_gear
  
  named_scope :active, :conditions => "status = 'active'"
  named_scope :battle_ready, :conditions => ["belongings.status = 'active' AND items.item_type IN (?) ", Item::BATTLE_TYPES], 
                             :include => [:item]
  named_scope :sellable, :conditions => ["belongings.status = 'holding'"], 
                          :order => "items.cost DESC"
  named_scope :standards, :conditions => ["items.item_type = 'Standard'"], 
                          :order => "items.cost DESC"
  named_scope :type_is, lambda { |item_type| 
    { :conditions => ["items.item_type = ?", item_type], :include => [:item] }
  }
                          
                          
  def after_initialize(*args)
    self.status ||= 'holding'
  end
  
  def validates_exclusivity
    return true unless new_record? && item_id && item.exclusive
    errors.add(:item_id, "exclusive item already possessed") if pet.owns_item?(item_id)
  end
  
  def use_item
    success = false
    if item.gear?
      success = update_attribute :status, (active? ? "holding" : "active")
    elsif item.food?
      success = item.eat!(pet)
      success = update_attribute :status, "expended" if success
    elsif item.practice?
      success = update_attribute :status, "expended"
    end
    return success
  end
  
  def apply
    if item.currency?
      pet.update_attribute(:kibble, pet.kibble + item.power)
      update_attribute(:status, "expended")
    end
  end
  
  def deactivate_other_gear
    if item.gear? && errors.empty? && active?
      other = pet.belongings.active.type_is(item.item_type).first
      other.update_attribute(:status, "holding") if other
    end
  end
  
  def expended?
    status == "expended"
  end
  
  def holding?
    status == "holding"
  end
  
  def active?
    status == "active"
  end
end