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
  
  def test_get_edit
    user = a User
    get :edit, :id => user
    assert_response :success
    assert_template :edit
  end
  
  def test_update_from_users
    user = a User
    put :update, :id => user, :user => { :email => 'user@domain.com' }, :area_id => nil
    user.reload
    assert_equal 'user@domain.com', user.email
    assert_redirected_to admin_users_path
  end
  
  def test_update_from_areas
    area = an Area
    user = a User
    put :update, :id => user, :user => { :email => 'user@domain.com' }, :area_id => area
    user.reload
    assert_equal 'user@domain.com', user.email
    assert_redirected_to admin_area_memberships_path(area)
  end
  
  def test_update_fails
    user = a User
    put :update, :id => user, :user => { :email => '' }
    assert_response :success
    assert_template :edit
    assert_not_nil user.email
  end
  
  def test_destroy
    user = a User
    assert_difference 'User.count', -1 do
      delete :destroy, :id => user
    end
    assert_redirected_to admin_users_path
  end

end
