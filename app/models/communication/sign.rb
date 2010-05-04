class Sign < ActiveRecord::Base
  SIGNINGS = ['Play', 'Hiss', 'Purr', 'Groom']
  
  class << self
    def signs_with(sender,recipient)
      SIGNINGS
    end
  end
end