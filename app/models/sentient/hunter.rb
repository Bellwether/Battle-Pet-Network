class Hunter < ActiveRecord::Base
  belongs_to :hunt
  belongs_to :pet
  belongs_to :strategy
  
  accepts_nested_attributes_for :strategy, :allow_destroy => false
  
  validates_presence_of :pet_id, :outcome
  validates_inclusion_of :outcome, :in => %w(won lost deadlocked)
  
  before_validation_on_create :set_outcome  
  validate :validates_pet_strategy
        
  def validates_pet_strategy
    errors.add(:strategy_id, "unknown strategy") if strategy && pet_id != strategy.combatant_id
  end
  
  def set_outcome
    self.outcome = "won"
  end
end