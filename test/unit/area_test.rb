require 'test_helper'

class AreaTest < ActiveSupport::TestCase

  def test_create_defaults
    area = Area.create(
      :name => 'Test Area'
    )
    assert_created area
    assert_equal Area::SEND_MODES[:immediate], area.send_mode
  end
  
  def test_create_requirements
    area = Area.create
    assert_errors_on area, :name
    Area.create(:name => 'Test NF', :slug => 'test-nf')
    assert_no_difference 'Area.count' do
      ['test-nf', 'test nf', 'test#NF'].each do |slug|
        area = Area.create(:name => 'Test NF 2', :slug => slug)
        assert_errors_on area, :slug
      end
    end
  end
  
  def test_create_dummy
    area = an Area
    assert_created area
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
  
  def test_send_mode_name
    area = an Area
    assert_equal :immediate, area.send_mode_name
    area.send_mode = Area::SEND_MODES[:batched]
    assert_equal :batched, area.send_mode_name
  end
  
end