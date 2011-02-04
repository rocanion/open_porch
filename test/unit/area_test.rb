require 'test_helper'

class AreaTest < ActiveSupport::TestCase

  def test_create_defaults
    area = Area.create(
      :name => 'Test Area',
      :slug => 'test-area'
    )
    assert_created area
    assert_equal Area::SEND_MODES[:immediate], area.send_mode
  end
  
  def test_create_requirements
    area = Area.create
    assert_errors_on area, :name
  end
  
  def test_create_dummy
    area = an Area
    assert_created area
  end
  
  def test_update_requirements
    area = an Area
    assert_created area
    area.published = true
    assert !area.valid?
    assert_errors_on area, :slug
  end
  
  def test_cascade_deletions
    area = an Area
    assert_created area
    membership = area.memberships.create_dummy
    assert_created membership
    post = area.posts.create_dummy  
    assert_created post
    area.reload
    assert_difference ['Area.count', 'Membership.count', 'Post.count', 'Issue.count'], -1 do
      area.destroy
    end
  end
  
end