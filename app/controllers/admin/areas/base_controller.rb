class Admin::Areas::BaseController < Admin::BaseController
  before_filter :require_authority_to_manage_areas
  before_filter :load_area

protected
  def load_area
    @area = Area.find(params[:area_id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end
end