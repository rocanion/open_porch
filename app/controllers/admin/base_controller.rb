class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :require_admin

protected
  def require_admin
    unless current_user.is_admin?
      redirect_to(user_path(current_user), :alert => "You're not authorized to access that page.") 
    end
  end
end
