require 'test_helper'

class BelongingTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
  end
  
  def test_apply
    currency = items(:kibble_pack)
    assert_difference '@pet.reload.kibble', +currency.power do
      belonging = @pet.belongings.create(:item => currency, :source => "award")
      assert_equal "expended", belonging.status
    end
  end
end