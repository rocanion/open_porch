require 'test_helper'

class AreaTest < ActiveSupport::TestCase

  def test_create_defaults
    area = Area.create(
      :name => 'Test Area',
      :slug => 'test-area'
    )
    assert_created area
  end
  
  def test_create_requirements
    area = Area.create
    assert_errors_on area, :name, :slug
  end
  
  def test_create_dummy
    area = a Area
    assert_created area
  end
  
  def test_cascade_deletions
    area = an Area
    assert_created area
    membership = area.memberships.create_dummy
    membership = area.posts.create_dummy
    assert_created membership
    assert_difference ['Area.count', 'Membership.count', 'Post.count'], -1 do
      area.destroy
    end
  end
  
end