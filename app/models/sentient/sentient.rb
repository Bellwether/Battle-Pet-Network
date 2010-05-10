class Sentient < ActiveRecord::Base
  has_many :hunts, :include => [:hunter]
  
  validates_inclusion_of :sentient_type, :in => %w(threat)
  
  cattr_reader :per_page
  @@per_page = 12
  
  named_scope :threats, :conditions => "sentient_type = 'threat'"
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end
end