require 'test_helper'

class Admin::Areas::PostsControllerTest < ActionController::TestCase

  def setup
    login_as(:admin)
  end

  def test_get_edit
    post = a Post
    xhr :get, :edit, :area_id => post.area, :id => post
    assert_response :success
  end
  
  def test_get_show
    post = a Post
    xhr :get, :show, :area_id => post.area, :id => post
    assert_response :success
  end
  
  def test_update
    post = a Post
    assert_not_equal post.title, 'New Title'
    xhr :put, :update, :area_id => post.area, :id => post, :post => {:title => 'New Title'}
    post.reload
    assert_equal post.title, 'New Title'
    assert_response :success
  end
  
  def test_update_fails
    post = a Post
    xhr :put, :update, :area_id => post.area, :id => post, :post => {:title => ''}
    assert assigns(:post).errors[:title].include?("can't be blank")
    assert_response :success
  end
  
  def test_toggle_reviewed_by
    post = a Post
    assert post.reviewed_by.nil?
    xhr :put, :toggle_reviewed_by, :area_id => post.area, :id => post
    post.reload
    assert_equal @controller.current_user.full_name, post.reviewed_by
    assert_response :success
  end
  
end
