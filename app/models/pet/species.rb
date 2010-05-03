class Species < ActiveRecord::Base
  has_many :breeds
  
  validates_presence_of :name  
end