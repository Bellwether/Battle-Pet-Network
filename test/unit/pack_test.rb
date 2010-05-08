require 'test_helper'

class PackTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @founder = pets(:persian)
    @standard = items(:fiberboard_pillar)
    @params = {:founder_id => @founder.id, :name => 'test pack', :standard_id => @standard.id}
  end

  def test_validates_founder
    pack = Pack.new(:founder_id => @pet.id, :name => 'test pack', :standard_id => @standard.id)
    rescue_save(pack)
    assert @pet.pack_id
    assert pack.errors.on(:founder_id)
  end
  
  def test_validates_founding_fee
    fee = AppConfig.packs.founding_fee
    @founder.update_attribute(:kibble, fee - 1)
    pack = Pack.new(@params)
    rescue_save(pack)
    assert pack.errors.on(:kibble)
  end
  
  def test_set_leader
    pack = Pack.new(@params)
    rescue_save(pack)
    assert pack.founder_id && pack.leader_id
    assert_equal pack.founder_id, pack.leader_id
  end
end