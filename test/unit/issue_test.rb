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
  
  def test_send_in_immediate_mode!
    # Create an area
    area = an Area
    assert_created area
    assert area.send_mode?(:immediate)
    
    # Create en issue
    assert_difference ['Post.count', 'Issue.count'], 1 do
      assert_emails 1 do
        post = area.posts.create_dummy
        assert_created post
        assert_nil area.current_issue
      end
    end
  end
  
  def test_send_in_batched_mode!
    # Create an area
    area = Area.create_dummy(:send_mode => Area::SEND_MODES[:batched])
    assert_created area
    assert area.send_mode?(:batched)
    
    # Create an issue
    issue = area.issues.create_dummy
    assert_created issue
    assert_nil issue.sent_at
    assert_equal issue, area.current_issue
    
    # Add two posts to the area
    post_1 = area.posts.create_dummy
    assert_created post_1
    assert_equal post_1.area, area
    
    post_2 = area.posts.create_dummy
    assert_created post_2
    assert_equal post_2.area, area
    
    assert_equal [post_1, post_2], area.posts.order(:id)
    assert_equal [], area.posts.in_issue(issue)
    assert_equal [post_1, post_2], area.posts.in_issue(nil).order(:id)

    # Add one post to the issue
    post_1.update_attribute(:issue_id, issue.id)
    area.reload
    assert_equal [post_1], area.posts.in_issue(issue)
    assert_equal [post_2], area.posts.in_issue(nil)

    # Send the issue
    assert_emails 1 do
      # Another issue should be created
      assert_difference 'Issue.count' do
        issue.send!
        assert issue.sent_at.is_a?(Time)
        assert_not_equal issue, area.current_issue
      end
    end

    issue = area.current_issue
    assert_equal [], area.posts.in_issue(issue)
    assert_equal [post_2], area.posts.in_issue(nil)

    # Add the second post to the issue
    post_2.update_attribute(:issue_id, issue.id)
    area.reload
    assert_equal [post_2], area.posts.in_issue(issue)
    assert_equal [], area.posts.in_issue(nil)
    
    # Send the second issue
    assert_emails 1 do
      # No new issue should be created
      assert_no_difference 'Issue.count' do
        issue.send!
        assert issue.sent_at.is_a?(Time)
        assert_nil area.current_issue
      end
    end
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
