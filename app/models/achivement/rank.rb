class Rank < ActiveRecord::Base
  belongs_to :ranking
  belongs_to :rankable, :polymorphic => true
end