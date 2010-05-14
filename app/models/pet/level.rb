class Level < ActiveRecord::Base
  belongs_to :breed
  has_many :pets
  
  named_scope :ranked, lambda { |rank|
    {:conditions=> ["rank = ?", rank ], :limit => 1}
  }
  
  def next_level
    Level.all(:conditions => ['rank = ? AND breed_id = ?', rank + 1, breed_id], :limit => 1).first
  end
end