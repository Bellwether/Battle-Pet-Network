class Leaderboard < ActiveRecord::Base
  validates_presence_of :rankable_type, :name, :ranked_count
  validates_inclusion_of :rankable_type, :in => %w(Pet Pack Shop)
end