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

  def test_validates_standard
    not_owned = items(:sisal_mast)
    assert !@pet.belongings.map(&:item).include?(not_owned)
    pack = Pack.new(:founder_id => @pet.id, :name => 'test pack', :standard_id => not_owned.id)
    rescue_save(pack)
    assert pack.errors.on(:standard_id)
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

  def test_updates_founder
    @founder.update_attribute(:kibble, AppConfig.packs.founding_fee)
    pack = Pack.new(@params)
    pack.send(:after_save)
    assert_equal pack.id, @founder.pack_id
  end
  
  def test_position_for
    stranger = pets(:persian)
    member = pets(:burmese)
    pack = packs(:alpha)
    assert_equal pack.founder_id, @pet.id
    assert_not_equal pack.id, stranger.pack_id
    assert_equal 'leader', pack.position_for(@pet)
    assert_equal 'member', pack.position_for(member)
    assert_equal nil, pack.position_for(stranger)
  end
  
  def test_battle_record
    pack = packs(:alpha)
    wins = 0
    loses = 0
    draws = 0
    pack.pack_members.each do |m|
      wins = wins + m.pet.wins_count
      loses = loses + m.pet.loses_count
      draws = draws + m.pet.draws_count
    end
    assert_equal "#{wins}/#{loses}/#{draws}", pack.battle_record
  end
  
  def test_membership_bonus
    pack = packs(:alpha)
    members = pack.pack_members
    ranks = members.collect(&:pet).collect(&:level_rank_count)
    total = 0
    ranks.each do |r|
      total = total + r
    end
    total = total * AppConfig.packs.member_bonus_modifier
    assert_equal pack.membership_bonus, total
  end
end