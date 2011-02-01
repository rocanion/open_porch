require 'test_helper'

class AreaSequenceTest < ActiveSupport::TestCase
  def test_defaults
    assert_difference ['Area.count', 'AreaSequence.count'] do
      area = an Area
      assert_created area
      assert_created area.area_sequence
      assert_not_nil area.area_sequence
    
      assert_equal 0, AreaSequence.counter_for(area.id)
      assert_equal 1, AreaSequence.increment(area.id)
      assert_equal 1, AreaSequence.counter_for(area.id)
      assert_equal 2, AreaSequence.increment(area.id)
      assert_equal 2, AreaSequence.counter_for(area.id)
    end
  end
  
  def test_cascade_deletions
    area = an Area
    assert_difference ['Area.count', 'AreaSequence.count'], -1 do
      area.destroy
    end
  end
  
end
