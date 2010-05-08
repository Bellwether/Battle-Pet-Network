require 'test_helper'

class PackTest < ActiveSupport::TestCase
  def setup
    @founder = pets(:persian)
    @params = {:founder_id => @founder.id, :name => 'test pack'}
  end
  
  def test_set_leader
    pack = Pack.new(@params)
    begin
     pack.save
    rescue
    end
    assert pack.founder_id && pack.leader_id
    assert_equal pack.founder_id, pack.leader_id
  end
end