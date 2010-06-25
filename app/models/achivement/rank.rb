class Rank < ActiveRecord::Base
  belongs_to :ranking
  belongs_to :rankable, :polymorphic => true
  
  after_create :award_prize
  
  def award_prize
    
  end
end