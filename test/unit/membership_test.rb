require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  
  def test_validations
    # Uniqueness
    membership = Membership.create_dummy
    assert_created membership
    membership = membership.clone
    membership.save
    assert_not_created membership
    assert membership.errors[:user_id].include?("has already been taken")
  end
  
  def test_create_dummy
    membership = Membership.create_dummy
    assert_created membership      
  end
  
end
