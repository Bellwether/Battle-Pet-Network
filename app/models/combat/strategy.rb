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
  
  def average_power
    0
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