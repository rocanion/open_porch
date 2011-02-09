require 'test_helper'

class UserActivityTest < ActiveSupport::TestCase
  
  def test_create_dummy
    user_activity = a UserActivity
    assert_created user_activity
  end
  
  def test_create_requirements
    user_activity = UserActivity.create
    assert_errors_on user_activity, :name, :url
    assert user_activity.errors[:name]
    assert user_activity.errors[:url]
  end
  
  def test_active_for_page_scope
    assert_equal [], UserActivity.active_for_page('Test User1', '/admin/users')
    u1 = UserActivity.find_or_create_by_name_and_url(:name => 'Test User1', :url => '/admin/users')    
    u2 = UserActivity.find_or_create_by_name_and_url(:name => 'Test User2', :url => '/admin/users')
    assert_equal [u2], UserActivity.active_for_page('Test User1', '/admin/users')
  end
  
  def test_set_expiration!
    user_activity = a UserActivity
    assert_not_nil user_activity.expires_at
    user_activity.set_expiration!
    assert (user_activity.expires_at > Time.now)
  end
  
end