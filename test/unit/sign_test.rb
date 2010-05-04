require 'test_helper'

class SignTest < ActiveSupport::TestCase
  def setup
  end
  
  def test_signs_with
    assert !Sign.signs_with( pets(:siamese), @new_pet).blank?
  end
end