class AreasController < Areas::BaseController
  skip_before_filter :login_required, :only => :show
  before_filter :load_area, :only => :show
  before_filter :initialize_search

  def show
  end

protected
  def load_area
    if logged_in?
      if current_user.is_admin?
        @area = Area.find(params[:id])
      else
        @area = current_user.areas.find(params[:id])
      end
    else
      @session_user = SessionUser.new
      @area = Area.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The area you were looking for was not found"
    if current_user.areas.empty?
      redirect_to user_path
    else
      redirect_to area_path(current_user.areas.first)
    end
  end

end
