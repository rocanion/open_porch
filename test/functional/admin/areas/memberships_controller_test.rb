require 'test_helper'

class Admin::Areas::MembershipsControllerTest < ActionController::TestCase

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
    get :index, :area_id => @area.id
    assert_equal "You're not authorized to access that page.", flash[:alert]
    assert_redirected_to area_path(@user.areas.first)
  end
  
  def test_get_index
    get :index, :area_id => @area
    assert_response :success
    assert_template :index
    assert assigns(:memberships)
  end
  
end
