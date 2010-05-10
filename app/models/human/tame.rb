class Tame < ActiveRecord::Base
  belongs_to :pet
  belongs_to :human  
  
  cattr_reader :per_page
  @@per_page = 5
    
  validates_inclusion_of :status, :in => %w(kenneled enslaved)
  
  named_scope :kenneled, :conditions => "tames.status = 'kenneled'"
  named_scope :enslaved, :conditions => "tames.status = 'enslaved'"
  
  def after_initialize(*args)
    self.status ||= 'kenneled'
  end  
end