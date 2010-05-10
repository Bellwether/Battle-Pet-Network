class Challenge < ActiveRecord::Base
  has_one :battle

  validates_presence_of :status, :challenge_type, :attacker_id
  validates_length_of :message, :in => 3..256, :allow_blank => true
  validates_inclusion_of :status, :in => %w(issued refused canceled expired resolved)
  validates_inclusion_of :challenge_type, :in => %w(1v1, 1v0, 1vG)
  
  def after_initialize(*args)
    self.status ||= 'issued'
  end
end