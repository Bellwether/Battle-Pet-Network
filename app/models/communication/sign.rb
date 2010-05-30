class Sign < ActiveRecord::Base
  SIGNINGS = ['play', 'hiss', 'purr', 'groom']
  
  belongs_to :sender, :class_name => "Pet", :foreign_key => "sender_id"
  belongs_to :recipient, :class_name => "Pet", :foreign_key => "recipient_id"
  
  validates_presence_of :sign_type, :sender_id, :recipient_id
  validates_inclusion_of :sign_type, :in => SIGNINGS
  
  validate :validates_endurance_cost, :validates_once_per_day
  
  after_create :exhaust_sender
  
  class << self
    def signs_with(sender,recipient)
      SIGNINGS
    end
  end
  
  def verb
    return case sign_type
    when 'play'
      'played with'
    when 'hiss'
      'hissed at'
    when 'purr'
      'purred to'
    when 'groom'
      'groomed'
    end
  end

  def validates_endurance_cost
    errors.add(:sender_id, "not enough endurance") if sender && 
                                                      sender.current_endurance < AppConfig.communication.sign_endurance_cost
  end

  def validates_once_per_day
    existing = Sign.exists?(["created_at >= (created_at >= DATE_ADD(NOW(), INTERVAL -24 HOUR)) AND sender_id = ? AND recipient_id = ?", 
                            sender_id,
                            recipient_id])
    errors.add(:recipient_id, "already sent a sign today") if existing
  end

  def exhaust_sender
    sender.update_attribute(:current_endurance, sender.current_endurance - AppConfig.communication.sign_endurance_cost)
  end
end