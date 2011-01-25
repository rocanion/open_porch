require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_create_defaults
    user = User.new(
      :email => 'user@example.com',
      :password => 'tester',
      :password_confirmation => 'tester'
    )
    user.role = 'admin'
    user.save
    assert_created user
  end

  def test_create_requirements
    user = User.create
  
    assert_errors_on user, :email, :password, :role
    assert user.errors[:email].include?("Please enter your email address")
    assert user.errors[:email].include?("The email address you entered is not valid")
    assert user.errors[:email].include?("The email address you entered is to short")
    assert user.errors[:password].include?("Please choose a password")
    assert user.errors[:password].include?("The password you entered is too short (minimum is 4 characters)")
    assert user.errors[:role].include?("can't be blank")
    assert user.errors[:role].include?("is not included in the list")
  end

  def test_create_dummy
    user = a User
    assert_created user
  end
  
end