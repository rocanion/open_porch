class AreasController < ApplicationController
  skip_before_filter :login_required,
    :only => :show
  before_filter :load_area,
    :only => :show

  def show
    @issue = @area.issues.sent.last
  end

protected
  def load_area
    if logged_in?
      @area = current_user.areas.find(params[:id])
    else
      @session_user = SessionUser.new
      @area = Area.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end

end
