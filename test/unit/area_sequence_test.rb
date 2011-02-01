require 'test_helper'

class AreaSequenceTest < ActiveSupport::TestCase
  def test_defaults
    code = AreaSequence.counter_for(21)
    
    assert_equal 0, code

    # Check again to ensure it's still zero
    code = AreaSequence.counter_for(21)
    
    assert_equal 0, code
  end
  
  def test_increment
    assert_equal 0, AreaSequence.counter_for(34)
    
    assert_equal 1, AreaSequence.increment(34)
                            
    assert_equal 1, AreaSequence.counter_for(34)
                            
    assert_equal 2, AreaSequence.increment(34)
                            
    assert_equal 2, AreaSequence.counter_for(34)
                            
    assert_equal 0, AreaSequence.counter_for(36)
  end

  # def test_generate
  #   ('a'..'z').each_with_index do |prefix, i|
  #     i.times do |j|
  #       assert_equal '%s%d' % [ prefix, j + 1 ], Sequence.generate(prefix)
  #     end
  #   end
  #   
  #   ('a'..'z').each_with_index do |prefix, i|
  #     assert_equal i, Sequence.counter_for(prefix)
  #   end
  # end
end
