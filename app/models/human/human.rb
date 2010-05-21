class Human < ActiveRecord::Base
  set_table_name 'humans'
  
  has_many :tames
  
  cattr_reader :per_page
  @@per_page = 10
  
  named_scope :random, :order => "(25 - difficulty) * RAND() DESC"  
  named_scope :random_for_pet, lambda { |pet| 
    { :conditions => ["required_rank <= ?", pet.level_rank_count], :order => "(25 - difficulty) * RAND() DESC" }
  }
  
  class << self  
    # finds a random human weighted by difficulty
    def find_random_human(pet=nil)
      return pet.blank? ? Human.random : Human.random_for_pet(pet)
    end
    
    def finds_human?(pet)
      div = AppConfig.occupations.find_human_chance_divisor.to_f
      chance = (pet.affection.to_f + pet.affection_bonus) / div
      val = 1 + rand(100)
      return val <= chance
    end  
  end
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end
end