require 'test_helper'

class Admin::AreasControllerTest < ActionController::TestCase
  
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
    assert assigns(:areas)
  end
  
  def test_get_new
    get :new
    assert_response :success
    assert_template :new
  end
  
  def test_create
    assert_difference 'Area.count', 1 do
      post :create, :area => area_params
    end
    assert_redirected_to admin_areas_path
  end
  
  def test_create_fails
    assert_no_difference 'Area.count' do
      post :create, :area => area_params(:name => '')
    end
    assert_response :success
    assert_template :new
  end
  
  def test_get_edit
    area = an Area
    get :edit, :id => area
    assert_response :success
    assert_template :edit
  end
  
  def test_update
    area = an Area
    put :update, :id => area, :area => { :name => '[EDIT] New Area Name'}
    area.reload
    assert_equal '[EDIT] New Area Name', area.name
    assert_redirected_to admin_areas_path
  end
  
  def test_update_fails
    area = an Area
    put :update, :id => area, :area => { :name => '' }
    assert_response :success
    assert_template :edit
    assert_not_nil area.name
  end
  
  def test_destroy
    area = an Area
    assert_difference 'Area.count', -1 do
      delete :destroy, :id => area
    end
    assert_redirected_to admin_areas_path
  end
protected
  def area_params(options = {})
    {
      :name => 'New Area',
      :slug => 'new-area'
    }.merge(options)
  end
end
