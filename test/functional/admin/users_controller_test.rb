require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  
  def setup
    login_as(:admin)
  end
  
  def test_require_admin
    login_as(:regular_user)
    get :index
    assert_equal "You're not authorized to access that page.", flash[:alert]
    assert_redirected_to user_path(session[:user_id])
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
