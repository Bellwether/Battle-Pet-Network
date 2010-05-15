class Hunt < ActiveRecord::Base
  include Combat
  
  belongs_to :sentient
  has_many :hunters
  
  accepts_nested_attributes_for :hunters, :allow_destroy => false
  
  validates_presence_of :sentient_id, :status, :logs
  validates_inclusion_of :status, :in => %w(gathering started ended)
  
  validates_presence_of :hunters
    
  validate :validates_required_rank
  
  def after_initialize(*args)
    self.status ||= 'started'
    self.logs ||= '--'
  end
  
  def validates_required_rank
    return if sentient.blank? || hunters.blank?
    hunters.each do |h|
      errors.add(:sentient_id, "required level too high") if h.pet.level_rank_count < sentient.required_rank
    end
  end
  
  def hunter
    if hunters.size == 1
      return hunters.first
    elsif hunters.size > 1
      return hunters
    end
  end
  
  def set_outcome
    hunters.each do |h|
      if combatant_defeated?(defender) && !combatant_defeated?(h.pet)
        outcome = "won"
      elsif !combatant_defeated?(defender) && combatant_defeated?(h.pet)
        outcome = "lost"
      elsif combatant_defeated?(defender) && combatant_defeated?(h.pet)        
        outcome = "deadlocked"
      end
      h.outcome = outcome
    end
    self.status = "ended"
  end
end