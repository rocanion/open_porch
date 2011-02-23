class Area::BaseController < ApplicationController
  before_filter :load_area
  before_filter :initialize_search
  
protected
  def load_area
    @area = current_user.areas.find(params[:area_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end
  
  def initialize_search
    params[:search] ||= {}
    @search = @area.posts.search(params[:search])
  end
end
