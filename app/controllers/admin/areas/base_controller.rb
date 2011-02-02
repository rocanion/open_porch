class Admin::Areas::BaseController < ApplicationController
  layout 'admin/areas'
  before_filter :load_users

protected
  def load_users
    @users = User.all.for(params[:area_id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end
end