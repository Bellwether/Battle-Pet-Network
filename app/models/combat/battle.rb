class Battle < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :winner, :class_name => "Pet", :foreign_key => "winner_id", :select => Pet::SELECT_BASICS
end