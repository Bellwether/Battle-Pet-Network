module Combat::CombatLogger
  require 'action_view/test_case'
  include ActionView::Helpers::AssetTagHelper
  
  LOG_STRUCT = {:rounds => [], 
                :outcome => "", 
                :attacker_awards => {}, 
                :defender_awards => {}}

  def logs
    (@logs ||= LOG_STRUCT)
  end
  
  def log_round(res)
    log = case res.description
      when CombatActions::Resolution::ALL_ATTACK
        "#{named(res.first)} #{verbed(res.first_action)} for #{res.first_damage} " <<
        "and #{named(res.second)} #{verbed(res.second_action)} for #{res.second_damage}."
      when CombatActions::Resolution::ALL_DEFEND
        "#{named(res.first)} #{verbed(res.first_action)} and #{named(res.second)} #{verbed(res.second_action)} " <<
        "but neither struck a blow."
      when CombatActions::Resolution::ONE_DEFEND_CUT_TWO_ATTACK
        "#{named(res.second)} UNDERCUT #{named(res.first)}'s rash #{res.second_action.name} " <<
        "with a countering #{res.second_action.name} for #{res.second_damage}."
      when CombatActions::Resolution::ONE_ATTACK_HIT_TWO_DEFEND
        "#{named(res.first)} #{verbed(res.first_action)} through " << 
        "#{named(res.second)}'s helpless #{res.second_action.name} " <<
        "for #{res.first_damage}."
      when CombatActions::Resolution::ONE_ATTACK_CUT_TWO_DEFEND
        "#{named(res.first)} UNDERCUT #{named(res.second)}'s misplaced #{res.second_action.name} " <<
        "with a painful #{res.first_action.name} for #{res.first_damage}."
      when CombatActions::Resolution::ONE_ATTACK_HIT_TWO_DEFENDED
        "#{named(res.first)} #{verbed(res.first_action)} for #{res.first_damage} as " <<
        "#{named(res.second)} #{verbed(res.second_action)} in defense."
      when CombatActions::Resolution::TWO_DEFEND_CUT_TWO_ATTACK
        ""
      when CombatActions::Resolution::TWO_ATTACK_HIT_TWO_DEFEND
        "#{named(res.first)} #{verbed(res.first_action)} through " << 
        "#{named(res.second)}'s helpless #{res.second_action.name} " <<
        "for #{res.first_damage}."
      when CombatActions::Resolution::TWO_ATTACK_CUT_TWO_DEFEND
        "#{named(res.second)} UNDERCUT #{named(res.first)}'s misplaced #{res.first_action.name} " <<
        "with a painful #{res.second_action.name} for #{res.second_damage}."
      when CombatActions::Resolution::TWO_ATTACK_HIT_TWO_DEFENDED
        "#{named(res.second)} #{verbed(res.second_action)} for #{res.second_damage} as " <<
        "#{named(res.first)} #{verbed(res.first_action)} in defense."
    end
  end
  
  def named(combatant)
    combatant.is_a?(Sentient) ? "the #{combatant.name.downcase}" : combatant.name
  end
  
  def verbed(action)
    text = action.name
    if text.match /te$/
      return text.gsub(/te$/,'t')
    elsif text.match /t$/
      return text.gsub(/t$/,'tted')
    elsif text.match /e$/
      return text.gsub(/e$/,'ed')
    elsif text.match /p$/
      return text.gsub(/p$/,'pt')
    else
      return "#{text}ed"
    end
  end
end