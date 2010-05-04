class Pet < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  belongs_to :breed, :foreign_key => "breed_id", :select => "id, name" 
  belongs_to :user, :foreign_key => "user_id", :select => "id, facebook_id, facebook_session_key, username"
  
  validates_presence_of :name, :slug, :status, :current_health, :current_endurance, :health, :endurance,
                        :power, :intelligence, :fortitude, :affection, :experience, :kibble,
                        :wins_count, :loses_count, :draws_count, :level_rank_count
  validates_length_of :name, :within => 3..64
  validates_length_of :slug, :within => 3..8
  validates_numericality_of :kibble, :greater_than_or_equal_to => 0
  validates_numericality_of :experience, :greater_than_or_equal_to => 0
  validates_inclusion_of :status, :in => %w(active abandoned)
  
  before_validation_on_create :populate_from_breed, :set_slug
  after_create :set_user
  
  def after_initialize(*args)
    self.status = 'active'
    self.kibble = 0
    self.experience = 0
    self.wins_count = 0
    self.loses_count = 0
    self.draws_count = 0
    self.level_rank_count = 1
  end  
  
  def populate_from_breed
    return if breed_id.blank?
    inheritable = Breed.find_by_id(breed_id)
    
    self.current_health = self.health = inheritable.health
    self.current_endurance = self.endurance = inheritable.endurance
    self.power = inheritable.power
    self.intelligence = inheritable.intelligence
    self.fortitude = inheritable.fortitude
    self.affection = inheritable.affection
  end
  
  def set_slug
    self.slug = truncate(name, :length => 8).parameterize unless name.blank?
  end
  
  def set_user
    User.find(user).update_attribute(:pet_id, self.id) unless user.blank?
  end
end