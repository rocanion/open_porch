require 'test_helper'

class Area::PostsControllerTest < ActionController::TestCase
  
  def setup
    login_as(:regular_user)
  end
  
  def test_new
    area = an Area
    assert_created area
    @controller.current_user.memberships.create!(:area => area)
    get :new, :area_id => area
    assert_response :success
    assert_template :new
  end
  
  def test_create
    area = an Area
    assert_created area
    @controller.current_user.memberships.create!(:area => area)
    assert_difference 'Post.count', 1 do
      post :create, :area_id => area, :post => { :title => "New Post", :content => 'test'}
    end
    assert_redirected_to area_path(area)
  end
  
  def test_create_fails
    area = an Area
    assert_created area
    @controller.current_user.memberships.create!(:area => area)
    assert_no_difference 'Post.count' do
      post :create, :area_id => area
    end
    assert_errors_on assigns(:post), :title, :content
    assert_response :success
    assert_template :new
  end
  
  def test_shouldnt_post_to_other_forums
    area = an Area
    assert_created area
    assert_no_difference 'Post.count' do
      post :create, :area_id => area
    end
    assert_response 404
  end
  
end
