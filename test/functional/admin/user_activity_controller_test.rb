require 'test_helper'

class Admin::UserActivityControllerTest < ActionController::TestCase
  
  def setup
    login_as(:admin)
    @user_activity = a UserActivity
  end
  
  def test_require_admin
    user = login_as(:regular_user)
    get :show, :id => @user_activity
    assert_equal "You're not authorized to access that page.", flash[:alert]
    assert_redirected_to area_path(user.areas.first)
  end
  
  def test_get_show
    get :show, :id => @user_activity 
    assert_response :success
    assert_template :show
  end
  
  def test_update
    put :update, :id => @user_activity
    assert (@user_activity.expires_at > Time.now)
  end
  
end