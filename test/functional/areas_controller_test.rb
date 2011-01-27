require 'test_helper'

class AreasControllerTest < ActionController::TestCase

  def test_get_show
    area = an Area
    get :show, :id => area
    assert_response :success
    assert_template :show 
  end

end
