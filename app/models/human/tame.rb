class Tame < ActiveRecord::Base
  belongs_to :pet
  belongs_to :human  
end