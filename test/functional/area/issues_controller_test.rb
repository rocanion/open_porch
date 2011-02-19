require 'test_helper'

class Area::IssuesControllerTest < ActionController::TestCase
  def setup
    login_as(:regular_user)
    @current_user = @controller.current_user
  end

  def test_get_index
    issue = Issue.create_dummy
    @current_user.memberships.create(:area => issue.area)
    get :index, :area_id => issue.area
    assert_response :success
    assert_template :index
  end
  
  def test_get_show
    issue = an Issue
    issue.update_attribute(:sent_at, Time.now)
    @current_user.memberships.create(:area => issue.area)
    get :show, :area_id => issue.area, :id => issue.number
    assert_response :success
    assert_template :show
  end
  
  def test_get_archive
    area = an Area
    @current_user.memberships.create(:area => area)
    get :index, :area_id => area, :year => 2011, :month => 01
    assert_response :success
    assert_template :index
  end
end