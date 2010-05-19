class Tame < ActiveRecord::Base
  belongs_to :pet
  belongs_to :human  
  
  cattr_reader :per_page
  @@per_page = 5
    
  validates_inclusion_of :status, :in => %w(kenneled enslaved)

  validate :validates_exclusivity
  
  named_scope :kenneled, :conditions => "tames.status = 'kenneled'" do
    def release(id)
      tame = find(id)
      release_award = tame.human.power * AppConfig.humans.release_multiplier
      tame.pet.update_attribute(:kibble, tame.pet.kibble + release_award)
      Tame.delete(id)
    end
    
    def enslave(id)
      find(id).update_attribute(:status, 'enslaved')
    end    
  end
  
  named_scope :enslaved, :conditions => "tames.status = 'enslaved'"
  
  def after_initialize(*args)
    self.status ||= 'kenneled'
  end  
  
  def validates_exclusivity
    errors.add(:human_id, "human already tamed") if human && 
                                                    pet && 
                                                    pet.tames.kenneled.map(&:human_id).include?(human.id)
  end
end