class Level < ActiveRecord::Base
  belongs_to :breed
  has_many :pets
  
  named_scope :ranked, lambda { |rank|
    {:conditions=> ["rank = ?", rank ], :limit => 1}
  }  
end