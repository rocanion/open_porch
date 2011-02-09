require 'test_helper'

class Admin::IssuesControllerTest < ActionController::TestCase
  
  def setup
    login_as(:admin)
  end

  def test_get_index
    area = an Area
    get :index, :area_id => area.id
    assert_response :success
    assert_template :index
  end
  
  def test_get_new
    area = an Area
    area.update_attribute(:send_mode, Area::SEND_MODES[:batched])
    assert_difference 'Issue.count', 1 do
      get :new, :area_id => area.id
    end
    assert_redirected_to edit_admin_area_issue_path(area, assigns(:issue))
  end
  
  def test_get_edit
    issue = an Issue
    get :edit, :area_id => issue.area, :id => issue
    assert_response :success
    assert_template :edit
  end

end
