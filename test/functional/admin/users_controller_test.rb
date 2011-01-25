require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  
  def setup
    login_as(:admin)
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
  
  def test_update
    user = a User
    put :update, :id => user, :user => { :email => 'user@domain.com' }
    user.reload
    assert_equal 'user@domain.com', user.email
    assert_redirected_to admin_users_path
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
