require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  def test_password_reset
    user = a User
    user.reset_perishable_token!
    assert_emails 1 do
      response = UserMailer.password_reset(user).deliver.first

      assert_equal "You have requested a new password", response.headers[:subject]
      assert_equal 2, response.arguments['content'].length
      response.arguments['content'].each do |content_type, body|
        assert_match /#{user.perishable_token}/, body
      end
      assert_equal user.email, response.to[0]
    end
  end

end
