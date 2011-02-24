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
    assert_errors_on post, :title, :content, :user_id, :area_id, :user_first_name,
                           :user_last_name, :user_email, :user_address, :user_city,
                           :user_state
  end
  
  def test_create_dummy
    area = Area.create_dummy(:send_mode => 'batched')
    assert_created area
    assert area.send_mode?(:batched)
    assert area.issues.empty?

    # Creating the first post will also create an issue
    assert_difference ['Post.count', 'Issue.count'] do
      assert_emails 0 do
        post = area.posts.create_dummy
        assert_created post
        assert_equal post.area.id, area.id
      end
    end

    # The second post will NOT create a new issue
    assert_difference 'Post.count' do
      assert_no_difference 'Issue.count' do
        assert_emails 0 do
          post = area.posts.create_dummy
          assert_created post
        end
      end
    end
  end

  def test_send_immediatelly
    area = Area.create_dummy(:send_mode => 'batched')
    assert_created area
    assert area.send_mode?(:batched)

    post = nil
    assert_difference ['Post.count', 'Issue.count'] do
      assert_emails 0 do
        post = area.posts.create_dummy
      end
    end
    
    assert_difference 'Issue.count' do
      assert_emails 1 do
        post.send_immediatelly!
      end
    end
    
  end
end
