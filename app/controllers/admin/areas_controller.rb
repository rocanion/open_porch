class Admin::AreasController < Admin::BaseController
  before_filter :build_area,
    :only => [:new, :create]
  before_filter :load_area,
    :except => [:index, :new, :create, :edit_borders, :bulk_update]
    
  def index
    @areas = Area.all
  end
  
  def new
  end
  
  def create
    @area.save!
    redirect_to([:admin, :areas], :notice => 'Area has been successfully created.')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def show
  end
  
  def edit
  end
  
  def edit_borders
    @areas = Area.all
  end
  
  def update
    @area.update_attributes!(params[:area])
    redirect_to([:admin, :areas], :notice => 'Area has been successfully updated.')
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end
  
  def bulk_update
    params[:areas].each do |index, area_params|
      area = Area.find(area_params[:id])
      area.coordinates = area_params[:coordinates]
      area.save!
    end
    render :nothing => true, :status => :ok
  rescue ActiveRecord::RecordInvalid
    render :nothing => true, :status => :bad_request
  end
  
  def destroy
    @area.destroy
    redirect_to([:admin, :areas], :notice => 'Area has been successfully deleted.')
  end

protected
  def build_area
    @area = Area.new(params[:area])
  end
  
  def load_area
    @area = Area.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end
end
