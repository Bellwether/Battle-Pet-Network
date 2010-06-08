class Hunt < ActiveRecord::Base
  include Combat
  serialize :logs
  
  belongs_to :sentient
  has_many :hunters
  
  accepts_nested_attributes_for :hunters, :allow_destroy => false
  
  validates_presence_of :sentient_id, :status
  validates_inclusion_of :status, :in => %w(gathering started ended)
  
  validates_presence_of :hunters
    
  validate :validates_required_rank
  
  def after_initialize(*args)
    self.status ||= 'started'
    self.logs ||= Combat::CombatLogger::LOG_STRUCT
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
      if combatant_defeated?(sentient) && !combatant_defeated?(h.pet)
        h.outcome = "won"
      elsif !combatant_defeated?(sentient) && combatant_defeated?(h.pet)
        h.outcome = "lost"
      elsif combatant_defeated?(sentient) && combatant_defeated?(h.pet)        
        h.outcome = "deadlocked"
      end
    end
    self.status = "ended"
  end
  
  def award!
    hunters.each do |h|
      h.pet.update_attribute(:kibble, h.pet.kibble + sentient.kibble) if h.outcome == "won"
    end
  end
end