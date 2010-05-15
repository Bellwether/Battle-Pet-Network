class Battle < ActiveRecord::Base
  include Combat
  
  belongs_to :challenge
  belongs_to :winner, :class_name => "Pet", :foreign_key => "winner_id", :select => Pet::SELECT_BASICS
  
  after_create :resolve_challenge

  def resolve_challenge
    challenge.update_attribute(:status,"resolved")
  end
end