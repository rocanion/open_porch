class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_from_cookie
  before_filter :login_required
  
protected
  def login_required
    redirect_to login_path unless logged_in?
  end
  
  def redirect_if_logged_in
    redirect_to area_path(current_user.areas.first) if logged_in?
  end
  
end
