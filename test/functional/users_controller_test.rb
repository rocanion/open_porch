require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @area = Area.create_dummy(
      :name => 'Oakledge',
      :border => Polygon.from_coordinates([[
        [44.450713, -73.227265],
        [44.456838, -73.225943],
        [44.455921, -73.218375],
        [44.449365, -73.220694],
        [44.450713, -73.227265]
      ]])
    )
  end
  def test_new_with_no_address
    get :new
    assert_redirected_to root_path
  end
  
  def test_new
    get :new, :user => {
      :address=>"123 Fake St", 
      :city=>"Burlington", 
      :state=>"Vermont", 
      :memberships_attributes=>{"0"=>{:area_id => @area.id}}
    }
    assert_response :success
    assert_template 'new'
    assert_equal assigns(:area), @area
  end
  
  def test_create
    assert_difference ['User.count', 'Membership.count'] do
      post :create, :user => {
        :email => 'user@example.com',
        :password => 'tester',
        :password_confirmation => 'tester',
        :address=>"123 Fake St", 
        :city=>"Burlington", 
        :state=>"Vermont",
        :first_name => 'John',
        :last_name => 'Tester', 
        :memberships_attributes=>{"0"=>{:area_id => @area.id}}
      }
      assert_redirected_to user_path
      assert_equal 'Welcome', flash[:notice]
      assert @controller.logged_in?
      assert_equal @controller.current_user, assigns(:user)
    end
  end
  
  def test_create_fails
    assert_no_difference ['User.count', 'Membership.count'] do
      post :create, :user => {}
      assert_redirected_to root_path
    end
  end
end
