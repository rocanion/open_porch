require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @regular_user = a User
    assert_created @regular_user

    @regular_user.update_attribute(:role, 'regular_user')
    assert !@regular_user.is_admin?

    area = an Area
    assert_created area

    @regular_user.areas << area
    assert_equal area, @regular_user.areas.first
  end

  # >> Login -----------------------------------------------------------

  def test_get_new
    get :new
    assert_response :success
    assert_template 'new'
    assert !@controller.logged_in?
    assert_nil @controller.current_user
  end
  
  def test_should_login_with_email_and_redirect
    post :create, :session_user => { :email => @regular_user.email, :password => @regular_user.password }
    assert_equal "Welcome, you are now logged in.", flash[:notice]
    assert_equal session[:user_id], @regular_user.id
    assert_redirected_to user_path
    assert @controller.logged_in?
    assert_equal @controller.current_user, @regular_user
  end
  
  def test_login_errors
    post :create, :session_user => { :email => 'a', :password => 'b' }
    assert_equal "Login failed. Did you mistype?", flash[:alert]
    assert_nil session[:user]
    assert_response :success
    assert_template 'new'
    assert !@controller.logged_in?
    assert_nil @controller.current_user
    
    assert !assigns(:session_user).valid?
    assert_errors_on assigns(:session_user), :email, :password
    assert assigns(:session_user).errors[:email].include?("The email address you entered is not valid")
    assert assigns(:session_user).errors[:email].include?("The email address you entered is to short")
    assert assigns(:session_user).errors[:password].include?("The password you entered is too short (minimum is 4 characters)")
  end
  
  def test_new_redirects_if_logged_in
    login_as(@regular_user)
    assert_equal session[:user_id], @regular_user.id
    assert @controller.logged_in?
    assert_equal @controller.current_user, @regular_user

    get :new
    assert_redirected_to user_path
  end
  
  def test_create_redirects_if_logged_in
    login_as(@regular_user)
    assert_equal session[:user_id], @regular_user.id
    assert @controller.logged_in?
    assert_equal @controller.current_user, @regular_user
    
    post :create, :session_user => { :email => @regular_user.email, :password => @regular_user.password }
    assert_redirected_to user_path
  end
  
  # >> Logout -----------------------------------------------------------

  def test_should_logout
    login_as(@regular_user)
    assert_equal session[:user_id], @regular_user.id
    assert @controller.logged_in?
    assert_equal @controller.current_user, @regular_user
    
    get :destroy
    assert_redirected_to login_path
    assert_nil cookies[:login_token]
    assert_nil session[:user_id]
    @regular_user.reload
    assert_nil @regular_user.remember_token
    assert !@controller.logged_in?
    assert_nil @controller.current_user
  end
  
  # >> Remember me -----------------------------------------------------------

  def test_remember_me
    post :create, :session_user => { :email => @regular_user.email, :password => @regular_user.password , :remember_me => '1' }
    assert_equal request.session[:user_id], @regular_user.id
    assert_not_nil assigns(:session_user).user.remember_token
    assert_equal assigns(:session_user).user.remember_token, cookies['login_token']
  end
end
