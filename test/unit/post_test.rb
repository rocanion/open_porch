require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  def test_create_defaults
    post = Post.create(
      :title => 'Test Post',
      :content => 'Lorem ipsum dolor sit amet',
      :user => (a User),
      :area => (an Area)
    )
    assert_created post
  end
  
  def test_create_requirements
    post = Post.create
    assert_errors_on post, :title, :content, :user_id, :area_id
  end
  
  def test_create_dummy
    post = a Post
    assert_created post
  end
  
end
