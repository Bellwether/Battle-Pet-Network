class Pack < ActiveRecord::Base
  KIBBLE_CONTRIBUTIONS = [25,50,100,200,300,400,500,1000]

  belongs_to :founder, :class_name => "Pet"
  belongs_to :leader, :class_name => "Pet"
  belongs_to :standard, :class_name => "Item", :select => 'id, name, description, power, required_rank'
  
  has_many :pack_members, :order => 'pack_members.position, pack_members.created_at', :include => {:pet => [:breed]}
  has_many :pets, :through => :pack_members
  has_many :spoils, :include => [:item], :order => 'items.cost DESC'

  before_validation_on_create :set_leader
  before_update :contribute_kibble
  after_create :update_founder
  
  validates_presence_of :founder_id, :standard_id, :name, :kibble, :status
  validates_length_of :name, :within => 3..64
  validates_numericality_of :kibble, :greater_than_or_equal_to => 0
  validates_inclusion_of :status, :in => %w(active disbanded insolvent)
  validate :validates_founder, :validates_founding_fee, :validates_standard
  
  named_scope :include_pack_members, :include => {:pack_members => :pet}

  attr_accessor :kibble_contribution
  
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
  
  def is_leader?(pet)
    position_for(pet) == "leader"
  end

  def set_leader
    self.leader_id = self.founder_id
  end
  
  def contribute_kibble
    self.kibble = kibble + kibble_contribution unless kibble_contribution.blank?
  end
  
  def update_founder
    founder.update_attribute(:pack_id, self.id)
  end
  
  def battle_record
    wins = pets.sum(:wins_count)
    loses = pets.sum(:loses_count)
    draws = pets.sum(:draws_count)
    return "#{wins}/#{loses}/#{draws}"
  end

  def membership_bonus
    return 0 if pack_members.size < 2 
    
    total_levels = pets.sum(:level_rank_count)
    return AppConfig.packs.member_bonus_modifier * total_levels
  end
  
  def position_for(pet)
    return "leader" if pet.id == self.leader_id
    
    pack_members.each do |m|
      return m.position if m.pet_id == pet.id
    end
    return nil
  end
  
  def invite_membership(sender,invitee)
    body = "#{sender.name} has invited you to join their pack #{name}."
    message = sender.outbox.new(:subject => "Pack Member Invite", :body => body, :recipient => invitee)
    if sender.pack_id != id
      message.errors.add(:sender_id, "can only invite to own pack")
      return message
    elsif !invitee.pack_id.blank?
      message.errors.add(:recipient_id, "pet already a pack member")
      return message
    else
      message.save
    end
    return message
  end
end