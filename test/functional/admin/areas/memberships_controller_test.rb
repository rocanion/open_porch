require 'test_helper'

class Admin::Areas::MembershipsControllerTest < ActionController::TestCase

  def setup
    login_as(:admin)
  end
  
  def test_require_admin
    area = an Area
    login_as(:regular_user)
    get :index, :area_id => area
    assert_equal "You're not authorized to access that page.", flash[:alert]
    assert_redirected_to user_path(session[:user_id])
  end
  
  def test_get_index
    area = an Area
    get :index, :area_id => area
    assert_response :success
    assert_template :index
    assert assigns(:memberships)
  end
  
end
