class Challenge < ActiveRecord::Base
  belongs_to :attacker, :class_name => "Pet"
  belongs_to :defender, :class_name => "Pet"
  belongs_to :attacker_strategy, :class_name => "Strategy"
  belongs_to :defender_strategy, :class_name => "Strategy"
  
  validates_presence_of :attacker_strategy
  
  has_one :battle

  validates_presence_of :status, :challenge_type, :attacker_id, :attacker_strategy
  validates_length_of :message, :in => 3..256, :allow_blank => true
  validates_inclusion_of :status, :in => %w(issued refused canceled expired resolved)
  validates_inclusion_of :challenge_type, :in => %w(1v1 1v0 1vG)
  
  accepts_nested_attributes_for :attacker_strategy, :allow_destroy => false
  accepts_nested_attributes_for :defender_strategy, :allow_destroy => false
  
  validate :validates_different_combatants, :validates_no_existing_challenge, :validates_prowling
  
  named_scope :issued, :conditions => "status = 'issued'"
  named_scope :resolved, :conditions => "status = 'resolved'"  
  named_scope :for_attacker, lambda { |attacker_id| 
    { :conditions => ["attacker_id = ?", attacker_id] }
  }  
  named_scope :for_defender, lambda { |defender_id| 
    { :conditions => ["defender_id = ?", defender_id] }
  }  
  
  def after_initialize(*args)
    self.status ||= 'issued' if attributes.include?(:status)
  end

  def validates_different_combatants
    errors.add_to_base("cannot challenge self") if attacker_id == defender_id
  end
  
  def validates_prowling
    errors.add(:attacker_id, "must be prowling to issue challenge") if attacker && !attacker.prowling?
    errors.add(:defender_id, "must be prowling to accept challenge") if defender && !defender.prowling?
  end
  
  def validates_no_existing_challenge
    return true unless new_record?
    existing_challenge = Challenge.exists?(
      ["status = 'issued' AND ((attacker_id = ? AND defender_id = ?) OR (attacker_id = ? AND defender_id = ?))", 
        attacker_id, defender_id, defender_id, attacker_id])
    errors.add_to_base("existing challenge already issued") if existing_challenge
  end
end