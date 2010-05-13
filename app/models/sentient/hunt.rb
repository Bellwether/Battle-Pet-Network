class Hunt < ActiveRecord::Base
  belongs_to :sentient
  has_many :hunters
  
  accepts_nested_attributes_for :hunters, :allow_destroy => false
  
  validates_presence_of :sentient_id, :status, :logs
  validates_inclusion_of :status, :in => %w(gathering started ended)
  
  validates_presence_of :hunters
    
  validate :validates_required_rank
  
  def after_initialize(*args)
    self.status ||= 'started'
    self.logs ||= '--'
  end
  
  def validates_required_rank
    return if sentient.blank? || hunters.blank?
    hunters.each do |h|
      errors.add(:sentient_id, "required level too high") if h.pet.level_rank_count < sentient.required_rank
    end
  end
end