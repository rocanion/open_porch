require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  
  def test_create_defaults
    membership = Membership.create_dummy
    assert_created membership
  end
  
  def test_validations
    # Presence
    membership = Membership.create_dummy(:user => nil, :area => nil)
    assert membership.errors[:user_id].include?("can't be blank")
    assert membership.errors[:area_id].include?("can't be blank")
    # Uniqueness
    membership = Membership.create_dummy
    assert_created membership
    membership = membership.clone
    membership.save
    assert_not_created membership
    assert membership.errors[:user_id].include?("has already been taken")
  end
  
  def test_create_dummy
    membership = a Membership
    assert_created membership
  end
  
end
