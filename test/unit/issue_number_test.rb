require 'test_helper'

class IssueNumberTest < ActiveSupport::TestCase
  def test_defaults
    assert_difference ['Area.count', 'IssueNumber.count'] do
      area = an Area
      assert_created area
      assert_created area.issue_number
    
      assert_equal 0, area.issue_number.current
      assert_equal 1, area.issue_number.next
      assert_equal 1, area.issue_number.current
      assert_equal 2, area.issue_number.next
      assert_equal 2, area.issue_number.current
    end
  end
  
  def test_cascade_deletions
    area = an Area
    assert_difference ['Area.count', 'IssueNumber.count'], -1 do
      area.destroy
    end
  end
  
end
