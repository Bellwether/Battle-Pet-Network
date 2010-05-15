module Combat
  require 'action_view/test_case'
  include CombatLogger
    
  def self.included(base)
    base.send :validate, :validates_combat
    base.send :after_validation, :run_combat
  end
  
  attr_accessor :current_round
  attr_accessor :attacker_damage, :defender_damage
  attr_accessor :attacker_experience, :defender_experience
    
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
  
  def combatants
    [attacker,defender]
  end
  
  def validates_combat
    return true unless combat_needs_to_occur?
    
    errors.add_to_base("attacker needed") if attacker.blank?
    errors.add_to_base("defender needed") if defender.blank?
    
    return errors.empty?
  end
  
  def run_combat
    return unless combat_needs_to_occur? && validates_combat
    
    respond_to?(:award!) ? award! : award_combatants
  end
  
  def combat_needs_to_occur?
    if self.respond_to?(:challenge)
      return self.new_record?
    elsif self.respond_to?(:hunters)
      return status == "started"
    end
  end
  
  def award_combatants
    return if end_result == EndResult::BOTH_UNCONSCIOUS
  end
  
  def combat_in_progress?
    in_progress = attacker.current_endurance > 0 &&
                  defender.current_endurance > 0 &&
                  attacker.current_health > 0 &&
                  defender.current_health > 0
    return in_progress
  end
  
  def end_result
    return EndResult::BOTH_EXHAUSTED if (attacker.current_endurance + defender.current_endurance == 0)
    return EndResult::BOTH_UNCONSCIOUS if (attacker.current_health + defender.current_health == 0)
    return EndResult::ATTACKER_WON if (defender.current_health == 0 || defender.current_endurance == 0)
    return EndResult::DEFENDER_WON if (attacker.current_health == 0 || attacker.current_endurance == 0)
    nil
  end
  
  class EndResult
    BOTH_EXHAUSTED = 1
    BOTH_UNCONSCIOUS = 2
    ATTACKER_WON = 3
    DEFENDER_WON = 4
  end  
end