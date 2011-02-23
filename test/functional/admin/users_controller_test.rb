require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = a User
    assert_created @user

    @user.update_attribute(:role, 'admin')
    assert @user.is_admin?

    @area =  Area.create_dummy(
      :name => 'Oakledge',
      :border => Polygon.from_coordinates([[
        [44.450713, -73.227265],
        [44.456838, -73.225943],
        [44.455921, -73.218375],
        [44.449365, -73.220694],
        [44.450713, -73.227265]
      ]])
    )
    assert_created @area

    @user.areas << @area
    assert_equal @area, @user.areas.first
    
    login_as(@user)
  end
  
  def test_require_admin
    @user.update_attribute(:role, 'regular_user')
    login_as(@user)
    get :index
    assert_equal "You're not authorized to access that page.", flash[:alert]
    assert_redirected_to area_path(@user.areas.first)
  end
  
  def test_get_index
    get :index
    assert_response :success
    assert_template :index
    assert assigns(:users)
  end
  
  def test_get_new
    get :new
    assert_response :success
    assert_template :new
  end
  
  def test_create
    assert_difference 'User.count', 1 do
      post :create, :user => user_params(:password => 'testtest', :password_confirmation => 'testtest')
    end
    assert_equal 'User was successfully created.', flash[:notice]
    assert_redirected_to admin_users_path
  end
  
  def test_creation_fail
    assert_no_difference 'User.count' do
      post :create, :user => user_params(:first_name => '')
    end
    assert_response :success
    assert_template :new
  end
  
  def test_get_edit
    user = a User
    get :edit, :id => user
    assert_response :success
    assert_template :edit
  end
  
  def test_update_from_users
    user = a User
    assert_not_equal 'user@domain.com', user.email
    assert_not_equal 'Test', user.first_name
    assert_not_equal 'Name', user.last_name
    assert_not_equal 'Test Address', user.address
    assert_not_equal 'Test City', user.city
    assert_not_equal 'Test State', user.state
    put :update, :id => user, :user => user_params, :area_id => nil
    user.reload
    assert_equal flash[:notice], 'User has been successfully updated.'
    assert_equal 'user@domain.com', user.email
    assert_equal 'Test', user.first_name
    assert_equal 'Name', user.last_name
    assert_equal 'Test Address', user.address
    assert_equal 'Test City', user.city
    assert_equal 'Test State', user.state
    assert_redirected_to admin_users_path
  end
  
  def test_update_from_areas
    area = an Area
    user = a User
    assert_not_equal 'user@domain.com', user.email
    assert_not_equal 'Test', user.first_name
    assert_not_equal 'Name', user.last_name
    assert_not_equal 'Test Address', user.address
    assert_not_equal 'Test City', user.city
    assert_not_equal 'Test State', user.state
    put :update, :id => user, :user => user_params, :area_id => area
    assert_equal flash[:notice], 'User has been successfully updated.'
    assert_equal 'user@domain.com', assigns(:user).email
    assert_equal 'Test', assigns(:user).first_name
    assert_equal 'Name', assigns(:user).last_name
    assert_equal 'Test Address', assigns(:user).address
    assert_equal 'Test City', assigns(:user).city
    assert_equal 'Test State', assigns(:user).state
    assert_redirected_to admin_area_memberships_path(area)
  end
  
  def test_update_fails
    user = a User
    put :update, :id => user, :user => { :email => '' }
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:user).email
    assert assigns(:user).errors[:email].include?("Please enter your email address")
    assert assigns(:user).errors[:email].include?("The email address you entered is to short")
    assert assigns(:user).errors[:email].include?("The email address you entered is not valid")
  end
  
  def test_destroy
    user = a User
    assert_difference 'User.count', -1 do
      delete :destroy, :id => user
    end
    assert_redirected_to admin_users_path
  end
  
protected
  def user_params(options = {})
    {
      :email => 'user@domain.com', 
      :first_name => 'Test', 
      :last_name => 'Name', 
      :address => 'Test Address',
      :city => 'Test City',
      :state => 'Test State'
    }.merge(options)
  end
end
