class Action < ActiveRecord::Base
  belongs_to :breed
  has_many :pets
  has_many :maneuvers
  
  validates_presence_of :breed_id, :action_type, :verb, :power
  validates_numericality_of :power, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 8
  validates_inclusion_of :action_type, :in => %w(offensive defensive)
end