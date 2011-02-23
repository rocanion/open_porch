require 'test_helper'

class AreaActivityTest < ActiveSupport::TestCase

  def test_create_dummy
    activity = an AreaActivity
    assert_created activity
  end
  
  def test_activity_tracking_for_memberships
    # Memberships
    assert_difference 'AreaActivity.count', 1 do
      @membership = Membership.create_dummy
      assert_equal 1, @membership.area.activities.first.new_users_count
    end
    assert_no_difference 'AreaActivity.count' do
      @membership.destroy
      assert_equal 1, @membership.area.activities.first.quitters_count
    end
  end
  
  def test_activity_tracking_for_posts  
    # Posts
    assert_difference ['Post.count', 'AreaActivity.count'], 1 do
      post = Post.create_dummy
      assert_equal 1, post.area.activities.first.new_posts_count
    end
  end
  
  def test_activity_tracking_for_issues
    # Create an area
    area = an Area
    assert_created area
    assert area.send_mode?(:immediate)
    
    # Create en issue
    assert_difference ['Post.count', 'Issue.count', 'AreaActivity.count'], 1 do
      assert_emails 1 do
        post = area.posts.create_dummy
        assert_created post
        assert_nil area.current_issue
        assert_equal 1, area.activities.first.issues_published_count
      end
    end
  end
  
  def test_activity_tracking_for_nonexistent_field
    area = an Area
    assert_created area
    assert_exception_raised nil, "Cannot find field in the list of trackable fields. Currently tracking: #{AreaActivity::TRACKABLE.join(', ')}" do
      assert_no_difference 'AreaActivity.count' do
        area.record_activity_for!(:blah)
      end
    end
  end

end
