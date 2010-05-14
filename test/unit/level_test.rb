require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  def test_next_level
    Breed.all.each do |b|
      levels = Level.all :conditions => "breed_id = #{b.id}"
      levels.each_with_index do |l,idx|
        assert l.rank + 1, l.next_level.rank unless idx == (levels.size - 1)
      end
    end
  end
end