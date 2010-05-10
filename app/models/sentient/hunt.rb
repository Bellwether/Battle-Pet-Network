class Hunt < ActiveRecord::Base
  belongs_to :sentient
  has_many :hunters
  
  accepts_nested_attributes_for :hunters, :allow_destroy => false
  
  validates_presence_of :sentient_id, :status, :logs
  validates_inclusion_of :status, :in => %w(gathering started ended)
  
  def after_initialize(*args)
    self.status ||= 'started'
    self.logs ||= '--'
  end
end