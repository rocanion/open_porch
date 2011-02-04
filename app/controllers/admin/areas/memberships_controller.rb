class Admin::Areas::MembershipsController < Admin::Areas::BaseController
  def index
    @memberships =  @area.memberships.includes(:user)
  end

end
