require 'test_helper'

class ProfileCacheColumnsTest < ActiveSupport::TestCase
  def setup
    @pet = pets(:siamese)
    # @cached_attributes = ['affection','intelligence','health','endurance','power','fortitude','affection','experience','shopkeeping']
    @cached_attributes = ['health','endurance','fortitude','power','affection','experience','defense']
  end
  
  def test_column_attributes
    @cached_attributes.each do |col|
      assert @pet.respond_to?("#{col}_bonus_count".to_sym)
    end
  end
  
  def test_column_update_methods
    @cached_attributes.each do |col|
      assert @pet.respond_to?("update_#{col}_bonus_count".to_sym)
      assert_difference ["@pet.#{col}_bonus_count"], +1 do
        @pet.send("update_#{col}_bonus_count", 1)
      end
    end
  end
end