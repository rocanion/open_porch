class Admin::BaseController < ApplicationController
  before_filter :login_required, :require_admin

protected
  def require_admin
    unless current_user.is_admin?
      redirect_to(user_path(current_user), :alert => "You're not authorized to access that page.") 
    end
  end
end
