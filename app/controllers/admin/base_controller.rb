class Admin::BaseController < ApplicationController
  layout 'admin'

protected
  def require_authority_to_manage_users
    unless current_user.has_authority_to?(:manage_users)
      redirect_to(area_path(current_user.areas.first), :alert => "You're not authorized to access that page.") 
    end
  end
  
  def require_authority_to_manage_areas
    unless current_user.has_authority_to?(:manage_areas)
      redirect_to(area_path(current_user.areas.first), :alert => "You're not authorized to access that page.") 
    end
  end
end
