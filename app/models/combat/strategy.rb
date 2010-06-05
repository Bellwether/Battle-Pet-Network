require "#{RAILS_ROOT}/lib/ruby/array"
      
class Strategy < ActiveRecord::Base
  belongs_to :combatant, :polymorphic => true
  has_many :maneuvers, :validate => false, :order => 'rank DESC'
  
  accepts_nested_attributes_for :maneuvers, :allow_destroy => false

  validates_presence_of :combatant_id, :combatant_type, :name, :status
  validates_inclusion_of :combatant_type, :in => %w(Pet Sentient)
  validates_inclusion_of :status, :in => %w(active saved used)
  
  before_validation_on_create :set_name
  
  named_scope :active, :conditions => ["strategies.status = 'active'"]
  
  def after_initialize(*args)
    self.status ||= 'used'
  end  
  
  def random_maneuver
    if maneuvers.blank?
      return nil
    else
      return maneuvers.random(maneuvers.map(&:rank))
    end
  end
  
  def average_power
    return 0 if maneuvers.blank?
    unique_actions = maneuvers.collect(&:action).uniq
    power = 0
    unique_actions.each do |a|
      power = power + a.power
    end
    return (power / unique_actions.size)
  end  
  
  def total_power
    return 0 if maneuvers.blank?
    unique_actions = maneuvers.collect(&:action).uniq
    power = 0
    unique_actions.each do |a|
      power = power + a.power
    end
    return power
  end
  
  def action_count_for(aid)
    return maneuvers.select{|m| m.action_id == aid}.size
  end
  
  def favorite_action_experience_bonus
    return 0 if maneuvers.blank? || !combatant.is_a?(Pet)
    
    bonus = AppConfig.experience.favorite_action_bonus
    exp = action_count_for(combatant.breed.favorite_action_id) * bonus
    exp = exp + (action_count_for(combatant.favorite_action_id) * bonus) unless combatant.favorite_action_id.blank?
    return exp
  end  
  
  def set_name
    maneuvers.each do |m|
      (self.name ||= "") << m.action.power.to_s
    end
    name_part = combatant.respond_to?(:name) ? combatant.name[0, [3, combatant.name.size].min ] : "ANON"
    weekday_part = Time.now.wday.to_s[0,2]
    day_part = Time.now.day
    month_part = Time.now.month
    
    self.name = "#{name_part}#{day_part}#{month_part}"
  end
end