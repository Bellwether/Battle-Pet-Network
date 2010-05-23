require 'test_helper'

class SentientTest < ActiveSupport::TestCase
  def test_populate
    Sentient.all.each do |sentient|
      sentient.update_attribute(:population, 0)
      assert_difference 'sentient.reload.population', +sentient.repopulation_rate do
        Sentient.populate
      end    
    end
  end
end