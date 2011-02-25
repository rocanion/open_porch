class Areas::BaseController < ApplicationController
  before_filter :load_area
  before_filter :initialize_search
  
protected
  def load_area
    if current_user.is_admin?
      @area = Area.find(params[:area_id] || params[:id])
    else
      @area = current_user.areas.find(params[:area_id] || params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The area you were looking for was not found"
    if current_user.areas.empty?
      redirect_to user_path
    else
      redirect_to area_path(current_user.areas.first)
    end
  end
  
  def initialize_search
    params[:search] ||= {}
    @search = @area.posts.search(params[:search])
  end
end
