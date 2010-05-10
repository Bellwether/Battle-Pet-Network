class Strategy < ActiveRecord::Base
  belongs_to :combatant, :polymorphic => true
  
  has_many :maneuvers, :order => 'rank DESC'
  
  validates_presence_of :combatant_id, :combatant_type, :name, :status
  validates_inclusion_of :combatant_type, :in => %w(Pet Sentient)
  validates_inclusion_of :status, :in => %w(active saved used)
  
  def after_initialize(*args)
    self.status ||= 'used'
  end  
end