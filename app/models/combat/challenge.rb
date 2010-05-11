class Challenge < ActiveRecord::Base
  belongs_to :attacker, :class_name => "Pet"
  belongs_to :defender, :class_name => "Pet"
  belongs_to :attacker_strategy, :class_name => "Strategy"
  belongs_to :defender_strategy, :class_name => "Strategy"
  
  has_one :battle

  validates_presence_of :status, :challenge_type, :attacker_id
  validates_length_of :message, :in => 3..256, :allow_blank => true
  validates_inclusion_of :status, :in => %w(issued refused canceled expired resolved)
  validates_inclusion_of :challenge_type, :in => %w(1v1 1v0 1vG)
  
  accepts_nested_attributes_for :attacker_strategy, :allow_destroy => false
  accepts_nested_attributes_for :defender_strategy, :allow_destroy => false
  
  validate :validates_different_combatants
  
  def after_initialize(*args)
    self.status ||= 'issued'
  end

  def validates_different_combatants
    errors.add_to_base("cannot challenge self") if attacker_id == defender_id
  end
end