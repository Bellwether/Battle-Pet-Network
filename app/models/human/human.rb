class Human < ActiveRecord::Base
  set_table_name 'humans'
  
  has_many :tames
  
  cattr_reader :per_page
  @@per_page = 10
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end  
end