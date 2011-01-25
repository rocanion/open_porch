require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def test_password_reset
    user = a User
    user.reset_perishable_token!
    assert_emails 1 do
      response = UserMailer.password_reset(user).deliver
      assert_equal "You have requested a new password", response.subject
      assert_equal 2, response.parts.length
      response.parts.each do |part|
        assert_match /#{user.perishable_token}/, part.body.to_s
      end
      assert_equal user.email, response.to[0]
    end
  end
end