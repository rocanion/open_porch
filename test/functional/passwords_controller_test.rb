require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
  end
  
  def test_create
    user = a User
    assert_created user
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post :create, :email => user.email
      assert_equal 'Email to reset password successfully sent.', flash[:notice]
      assert_redirected_to login_path
      user.reload
      assert_not_nil user.perishable_token
    end
    response = ActionMailer::Base.deliveries.last
    assert_equal 2, response.parts.length
    response.parts.each do |part|
      assert_match /#{user.perishable_token}/, part.body.to_s
    end
    assert_equal user.email, response.to[0]
  end
  
  def test_edit
    user = a User
    user.reset_perishable_token!
    get :edit, :id => user.perishable_token
    assert_response :success
    assert_template 'edit'
  end
  
  def test_edit_redirects_on_invalid_perishable_token
    user = a User
    user.reset_perishable_token!
    get :edit, :id => user.perishable_token + 'bogus'
    assert_redirected_to login_path
  end

  def test_update
    user = a User
    user.reset_perishable_token!
    assert !user.password_match?('newpassword')
    put :update, :id => user.perishable_token, :user => {:password => 'newpassword', :password_confirmation => 'newpassword'}
    assert_redirected_to user_path(user)
    user.reload
    assert_nil user.perishable_token
    assert user.password_match?('newpassword')
  end
  
  def test_update_redirects_on_invalid_perishable_token
    user = a User
    user.reset_perishable_token!
    put :update, :id => user.perishable_token + 'bogus', :user => {:password => 'newpassword', :password_confirmation => 'newpassword'}
    assert_redirected_to login_path
    user.reload
    assert_not_nil user.perishable_token
  end
end
