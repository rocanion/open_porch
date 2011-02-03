require 'test_helper'

class IssueTest < ActiveSupport::TestCase

  def test_create_defaults
    area = an Area
    issue = Issue.create(
      :subject => 'Test issue',
      :area => area,
      :scheduled_at => 2.days.from_now
    )
    assert_equal 1, issue.number
    assert_created issue
  end
  
  def test_create_requirements
    issue = Issue.create(:scheduled_at => 2.days.ago)
    assert_errors_on issue, :subject, :area_id, :scheduled_at
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
  
  # def test_send!
  #   issue = an Issue
  #   assert_nil issue.sent_at
  #   assert_emails 1 do
  #     issue.send!
  #   end
  #   assert issue.sent_at.is_a?(Time)
  # end

end
