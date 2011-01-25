require 'test_helper'

class SessionUserTest < ActiveSupport::TestCase
  
  def test_create_defaults
    session_user = SessionUser.new(
      :email => 'test@test.com',
      :password => 'password'
    )
    assert session_user.valid?
    assert_equal session_user.email, 'test@test.com'
    assert_equal session_user.password, 'password'
    assert_nil session_user.user
  end
  
  def test_create_requirements
    session_user = SessionUser.new
    assert !session_user.valid?
    assert_errors_on session_user, :email, :password
    assert session_user.errors[:email].include?("Please enter your email address")
    assert session_user.errors[:email].include?("The email address you entered is not valid")
    assert session_user.errors[:email].include?("The email address you entered is to short")
    assert session_user.errors[:password].include?("Please choose a password")
    assert session_user.errors[:password].include?("The password you entered is too short (minimum is 4 characters)")
  end
  
  def test_successful_authentication
    user = a User
    session_user = SessionUser.create(
      :email => user.email,
      :password => user.password
    )
    assert session_user.valid?
    assert_equal session_user.email, user.email
    assert_equal session_user.password, user.password
    assert_equal session_user.user, user
  end
  
  def test_failed_authentication
    user = a User
    session_user = SessionUser.create(
      :email => user.email,
      :password => '-bugus-'
    )
    assert session_user.valid?
    assert_equal session_user.email, user.email
    assert_equal session_user.password, '-bugus-'
    assert_nil session_user.user
  end
end