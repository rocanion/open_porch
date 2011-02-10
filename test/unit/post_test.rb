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
      assert post.area.send_mode?(:immediate)
    end
  end
  
  def test_create_requirements
    post = Post.create
    assert_errors_on post, :title, :content, :user_id, :area_id
  end
  
  def test_create_dummy
    area = Area.create_dummy(:send_mode => :batched)
    assert_created area
    assert area.issues.empty?

    assert_difference ['Post.count', 'Issue.count'] do
      post = area.posts.create_dummy
      assert_created post
      assert_equal post.area.id, area.id
      assert post.area.send_mode?(:batched)
    end

    assert_difference 'Post.count' do
      assert_no_difference 'Issue.count' do
        post = area.posts.create_dummy
        assert_created post
      end
    end
  end
  
end
