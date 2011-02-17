require 'test_helper'

class AreaActivityTest < ActiveSupport::TestCase

  def test_create_dummy
    activity = an AreaActivity
    assert_created activity
  end

end
