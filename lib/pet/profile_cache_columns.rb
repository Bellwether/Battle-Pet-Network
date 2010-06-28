module Pet::ProfileCacheColumns
  require 'action_view/test_case'
   
  def update_health_bonus_count(val)
    update_attribute(:health_bonus_count, [(health_bonus_count + val), 0].max )
  end
   
  def update_endurance_bonus_count(val)
    update_attribute(:endurance_bonus_count, [(endurance_bonus_count + val), 0].max )
  end

  def update_experience_bonus_count(val)
    update_attribute(:experience_bonus_count, [(experience_bonus_count + val), 0].max )
  end

  def update_fortitude_bonus_count(val)
    update_attribute(:fortitude_bonus_count, [(fortitude_bonus_count + val), 0].max )
  end

  def update_power_bonus_count(val)
    update_attribute(:power_bonus_count, [(power_bonus_count + val), 0].max )
  end

  def update_defense_bonus_count(val)
    update_attribute(:defense_bonus_count, [(defense_bonus_count + val), 0].max )
  end

  def update_intelligence_bonus_count(val)
    update_attribute(:intelligence_bonus_count, [(intelligence_bonus_count + val), 0].max )
  end

  def update_affection_bonus_count(val)
    update_attribute(:affection_bonus_count, [(affection_bonus_count + val), 0].max )
  end
  
  def recalculate_defense_bonus
    
  end
end