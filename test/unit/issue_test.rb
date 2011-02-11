require 'test_helper'

class IssueTest < ActiveSupport::TestCase

  def test_create_defaults
    area = an Area
    issue = Issue.create(
      :area => area,
      :scheduled_at => 2.days.from_now
    )
    assert_equal 1, issue.number
    assert_created issue
  end
  
  def test_create_requirements
    issue = Issue.create(:scheduled_at => 2.days.ago)
    assert_errors_on issue, :area_id, :scheduled_at
    assert issue.errors[:scheduled_at].include?("can't be in the past.")
  end
  
  def test_create_dummy
   issue = an Issue
   assert_created issue
  end
  
  def test_cascade_deletions
    post = a Post
    assert_created post
    assert post.issue.is_a?(Issue)
    post.reload
    assert_difference ['Post.count', 'Issue.count'], -1 do
      post.issue.destroy
    end
  end
  
  def test_send!
    issue = an Issue
    assert_nil issue.sent_at
    assert_emails 1 do
      issue.send!
    end
    assert issue.sent_at.is_a?(Time)
  end

  def test_issue_number
    # Create one area
    area = an Area
    assert_created area
    # Add an issue
    issue = area.issues.create_dummy
    assert_created issue
    area.reload
    assert_equal 1, issue.number
    assert_equal 1, area.issue_number.current
    # Add another issue
    issue = area.issues.create_dummy
    assert_created issue
    area.reload
    assert_equal 2, issue.number
    assert_equal 2, area.issue_number.current
    
    # Create another area
    area = an Area
    assert_created area
    # Add an issue
    issue = area.issues.create_dummy
    assert_created issue
    area.reload
    assert_equal 1, issue.number
    assert_equal 1, area.issue_number.current
    # Add another issue
    issue = area.issues.create_dummy
    assert_created issue
    area.reload
    assert_equal 2, issue.number
    assert_equal 2, area.issue_number.current
  end
  
end
