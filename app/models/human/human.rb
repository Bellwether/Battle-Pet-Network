class Human < ActiveRecord::Base
  set_table_name 'humans'
  
  has_many :tames
end