class Biography < ActiveRecord::Base
  belongs_to :pet
  
  LIFESTYLES = ['Indoor','Outdoor']
  COLORS = ['Amaranth','Amber','Beige','Black','Blue','Brown','Cerise','Cerulean','Coral','Crimson','Cyan','Erin','Gold','Gray','Green','Harlequin','Indigo','Jade','Lavender','Lilac','Magenta','Magenta Rose','Maroon','Olive','Orange','Purple','Red','Scarlet','Silver','Taupe','Teal','Turquoise','Violet','Viridian','White','Yellow']
  CIRCADIAN = ['Nocturnal','Diurnal','Crepuscular']
  PEDIGREES = ['Thoroughbred','Purebred','Mongrel']
  SEASONS = ['Spring','Summer','Autumn','Winter']
  VOICES = ['Smooth','Galloping','Stentorian','Gentle','Silky','Shrill']
  FOODS = ['Fresh Fish','Dairy','Plants','Delicacies','Red Meat','Treats','Pate']
  TEMPERAMENTS = ['Aloof','Headstrong','Inquisitive','Mischievous','Neurotic','Paranoid','Somber','Violent']
  ZODIAC = ['Mouser','Arch','Mittens','Crook-Tail']
  GENDERS = ['Tom', 'Queen']
  PASTIMES = ['Cuddling','Eating','Exploring','Hunting','Playing','Sleeping','Grooming','']
  COMPOSERS = ['J.S. Bach']
  PHILOSOPHERS = ['Descartes']

  validates_presence_of :pet_id,:temperament,:lifestyle,:gender,:favorite_color,:favorite_food,:favorite_pastime,
                        :favorite_season,:pedigree,:circadian,:voice,:zodiac,:birthday,:siblings,:description
  validates_length_of :description, :in => 64..2048
  validates_numericality_of :siblings, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 8
  validates_inclusion_of :lifestyle, :in => LIFESTYLES
  validates_inclusion_of :favorite_color, :in => COLORS  
  validates_inclusion_of :favorite_season, :in => SEASONS  
  validates_inclusion_of :favorite_food, :in => FOODS
  validates_inclusion_of :favorite_pastime, :in => PASTIMES
  validates_inclusion_of :favorite_composer, :in => COMPOSERS
  validates_inclusion_of :favorite_philosopher, :in => PHILOSOPHERS
  validates_inclusion_of :circadian, :in => CIRCADIAN
  validates_inclusion_of :pedigree, :in => PEDIGREES
  validates_inclusion_of :voice, :in => VOICES
  validates_inclusion_of :temperament, :in => TEMPERAMENTS
  validates_inclusion_of :zodiac, :in => ZODIAC
  validates_uniqueness_of :pet_id
  
  after_create :reward_pet
  
  def reward_pet
    pet.kibble = (pet.kibble + AppConfig.awards.biography)
    pet.save
  end
end