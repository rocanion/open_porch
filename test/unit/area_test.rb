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
end
