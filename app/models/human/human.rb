class Human < ActiveRecord::Base
  set_table_name 'humans'
  
  cattr_reader :per_page
  @@per_page = 10
  
  has_many :tames
  
  def slug
    name.downcase.gsub(/\s/,'-')
  end  
end