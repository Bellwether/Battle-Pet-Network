require 'test_helper'

class ActivityStreamTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    @user = users(:one)
  end
  
  def test_set_polymorph_data
    [@pet,@user].each do |m|
      ['actor','object','indirect_object'].each do |a|
        activity = ActivityStream.new(a.to_sym => m)
        activity.set_polymorph_data
        if m.is_a?(Pet)
          assert_equal m.name, activity[:activity_data]["#{a}_name".to_sym]
        elsif m.is_a?(User)
          assert_equal m.normalized_name, activity[:activity_data]["#{a}_name".to_sym]
        end
      end
    end
  end
  
  def test_set_description_data
    ['registration','referer','daily-login','invitation'].each do |ns|
      activity = ActivityStream.new(:namespace => ns, :actor => @pet, :object => @pet, :indirect_object => @pet, :category => 'analytics')
      activity.set_description_data
      assert_not_nil activity.activity_data[:description]
    end
  end
end