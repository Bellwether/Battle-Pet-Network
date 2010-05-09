class Pack < ActiveRecord::Base
  belongs_to :founder, :class_name => "Pet"
  belongs_to :leader, :class_name => "Pet"
  belongs_to :standard, :class_name => "Item", :select => 'id, name, description, power, required_rank'
  
  has_many :pack_members, :order => 'pack_members.position, pack_members.created_at'
  has_many :spoils, :include => [:item], :order => 'items.cost DESC'

  before_validation_on_create :set_leader
  
  validates_presence_of :founder_id, :standard_id, :name, :kibble, :status
  validates_length_of :name, :within => 3..64
  validates_numericality_of :kibble, :greater_than_or_equal_to => 0
  validates_inclusion_of :status, :in => %w(active disbanded insolvent)
  validate :validates_founder, :validates_founding_fee, :validates_standard
  
  def after_initialize(*args)
    self.status ||= 'active'
    self.kibble ||= 0
  end
  
  def validates_founder
    errors.add(:founder_id, "already pack member") if founder && founder.pack_id
  end
  
  def validates_standard
    errors.add(:standard_id, "not in founders possession") if standard_id && founder_id && !founder.belongings.map(&:item_id).include?(standard.id)
  end
  
  def validates_founding_fee
    errors.add(:kibble, "cannot pay founding fee") if founder && founder.kibble < AppConfig.packs.founding_fee
  end

  def set_leader
    self.leader_id = self.founder_id
  end
  
  def member_bonus
    0
  end
  
  def position_for(pet)
    "member"
  end
end