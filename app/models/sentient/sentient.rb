class Sentient < ActiveRecord::Base
  has_many :hunts, :include => [:hunter]
  has_one :strategy, :as => :combatant, :dependent => :destroy
  
  validates_inclusion_of :sentient_type, :in => %w(threat)
  validates_numericality_of :required_rank, :greater_than_or_equal_to => 1
  
  cattr_reader :per_page
  @@per_page = 12
  
  named_scope :threats, :conditions => "sentient_type = 'threat'"
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end
end