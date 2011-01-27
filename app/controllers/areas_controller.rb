class AreasController < ApplicationController
  before_filter :load_area,
    :only => :show
    
  def index
    @areas = Area.closest_from(Area.first.center, 400)
  end
  
  def show
  end

protected
  def load_area
    @area = Area.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end

end
