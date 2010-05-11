class Challenge < ActiveRecord::Base
  belongs_to :attacker, :polymorphic => true
  belongs_to :defender, :polymorphic => true
  belongs_to :attacker_strategy, :class_name => "Strategy"
  belongs_to :defender_strategy, :class_name => "Strategy"
  
  has_one :battle

  validates_presence_of :status, :challenge_type, :attacker_id
  validates_length_of :message, :in => 3..256, :allow_blank => true
  validates_inclusion_of :status, :in => %w(issued refused canceled expired resolved)
  validates_inclusion_of :challenge_type, :in => %w(1v1, 1v0, 1vG)
  
  def after_initialize(*args)
    self.status ||= 'issued'
  end
end