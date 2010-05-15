module Combat
  require 'action_view/test_case'
  include CombatLogger
    
  def self.included(base)
    base.send :validate, :validates_combat
  end
  
  def attacker
    if self.respond_to?(:challenge)
      return challenge.attacker
    elsif self.respond_to?(:hunters)
      return hunter.pet
    end
  end
  
  def defender
    if respond_to?(:challenge)
      return challenge.defender
    elsif respond_to?(:hunters)
      return sentient
    end
  end
  
  def validates_combat
    return unless combat_needs_to_occur?
  end
  
  def combat_needs_to_occur?
    if self.respond_to?(:challenge)
      return self.new_record?
    elsif self.respond_to?(:hunters)
      return status == "started"
    end
  end
end