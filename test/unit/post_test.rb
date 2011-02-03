require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  def test_create_defaults
    assert_difference ['Post.count', 'Issue.count'], 1 do
      post = Post.create(
        :title => 'Test Post',
        :content => 'Lorem ipsum dolor sit amet',
        :user => (a User),
        :area => (an Area)
      )
    end
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
