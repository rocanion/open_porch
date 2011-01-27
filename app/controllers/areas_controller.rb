class AreasController < ApplicationController
  skip_before_filter :login_required,
    :only => :show
  before_filter :load_area,
    :only => :show

  def show
    unless logged_in?
      @session_user = SessionUser.new
    end
  end

protected
  def load_area
    @area = Area.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end

end
