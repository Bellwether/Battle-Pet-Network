class Maneuver < ActiveRecord::Base
  belongs_to :strategy
  belongs_to :action
  
  validates_presence_of :rank, :action_id, :strategy_id
  validates_numericality_of :rank  
end