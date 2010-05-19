class Belonging < ActiveRecord::Base
  belongs_to :pet
  belongs_to :item
  
  validates_presence_of :item_id, :pet_id, :source, :status
  validates_inclusion_of :status, :in => %w(active holding expended)
  validates_inclusion_of :source, :in => %w(scavenged purchased gift award)

  named_scope :battle_ready, :conditions => ["belongings.status = 'active' AND items.item_type IN (?) ", Item::BATTLE_TYPES], 
                             :include => [:item]
  named_scope :sellable, :conditions => ["belongings.status = 'holding'"], 
                          :order => "items.cost DESC"
  named_scope :standards, :conditions => ["items.item_type = 'Standard'"], 
                          :order => "items.cost DESC"
                          
  after_create :apply                          
                          
  def after_initialize(*args)
    self.status ||= 'holding'
  end
  
  def apply
    if item.currency?
      pet.update_attribute(:kibble, pet.kibble + item.power)
      update_attribute(:status, "expended")
    end
  end
end