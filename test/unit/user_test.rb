require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_create_defaults
    user = User.create(
      :email => 'user@domain.com'
    )
    assert_created user
  end
  
  def test_create_dummy
    user = a User
    assert_created user
  end
  
  def test_cascade_deletions
    user = a User
    assert_created user
    membership = user.memberships.create_dummy
    assert_created membership
    assert_difference ['User.count', 'Membership.count'], -1 do
      user.destroy
    end
  end
  
end