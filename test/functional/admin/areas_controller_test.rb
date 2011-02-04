require 'test_helper'

class Admin::AreasControllerTest < ActionController::TestCase
  
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
    assert assigns(:areas)
  end
  
  def test_get_new
    get :new
    assert_response :success
    assert_template :new
  end
  
  def test_create
    assert_difference ['Area.count', 'IssueNumber.count'], 1 do
      post :create, :area => area_params
    end
    assert_redirected_to admin_areas_path
  end
  
  def test_create_fails
    assert_no_difference ['Area.count', 'IssueNumber.count'] do
      post :create, :area => area_params(:name => '')
    end
    assert_response :success
    assert_template :new
  end
  
  def test_create_from_js
    assert_difference ['Area.count', 'IssueNumber.count'], 1 do
      xhr :post, :create, :area => area_params
    end
    assert_response :success
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
    assert_difference ['Area.count', 'IssueNumber.count'], -1 do
      delete :destroy, :id => area
    end
    assert_redirected_to admin_areas_path
  end
  
  def test_edit_borders
    get :edit_borders, :id => @area.id
    assert_response :success
    assert_template :edit_borders
    assert_equal [@area], assigns(:areas)
    assert_equal @area, assigns(:selected_area)
  end
  
  def test_bulk_update
    skip # < --------------------
    xhr :post, :bulk_update, "areas"=>{
      "0"=>{
        "id"=> @area.id, 
        "coordinates"=>{"0"=>["44.471237230753886", "-73.23112146041126"], "1"=>["44.46936923281188", "-73.22386876723499"], "2"=>["44.4617123643827", "-73.22558538100452"]}
      }
    }
        
    new_area = Area.find(@area.id)
    puts new_area.to_a.to_yaml
    assert_equal [44.450713, -73.227265], [area.border.first.points.first.x, area.border.first.points.first.y]
  end
  
protected
  def area_params(options = {})
    {
      :name => 'New Area',
      :slug => 'new-area'
    }.merge(options)
  end
end
