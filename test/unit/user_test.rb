require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_create_defaults
    user = User.new(
      :email => 'user@example.com',
      :password => 'tester',
      :password_confirmation => 'tester',
      :address => 'street 1',
      :city => 'Burlington',
      :state => 'Vermont',
      :first_name => 'John',
      :last_name => 'Tester'
    )
    user.save
    assert_created user
  end

  def test_create_requirements
    user = User.create
  
    assert_errors_on user, :email, :password, :address, :city, :state, :first_name, :last_name
    assert user.errors[:email].include?("Please enter your email address")
    assert user.errors[:email].include?("The email address you entered is not valid")
    assert user.errors[:email].include?("The email address you entered is to short")
    assert user.errors[:password].include?("Please choose a password")
    assert user.errors[:password].include?("The password you entered is too short (minimum is 4 characters)")
    assert user.errors[:address].include?("Please enter your full address")
    assert user.errors[:city].include?("Please enter your full address")
    assert user.errors[:state].include?("Please enter your full address")
    assert user.is_regular_user?
  end

  def test_create_dummy
    user = a User
    assert_created user
  end
  
  def test_cascade_deletions
    user = a User
    assert_created user
    membership = user.memberships.create_dummy
    membership = user.posts.create_dummy
    assert_created membership
    assert_difference ['User.count', 'Membership.count', 'Post.count'], -1 do
      user.destroy
    end
  end
  
  def test_member_of?
    user = a User
    assert_created user
    membership = user.memberships.create_dummy
    assert user.member_of?(membership.area)
  end
  
end