class Admin::AreasController < Admin::BaseController
  before_filter :build_area,
    :only => [:new, :create]
  before_filter :load_area,
    :except => [:index, :new, :create, :edit_borders]
  
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
  
  def edit
  end
  
  def edit_borders
    
  end
  
  def update
    @area.update_attributes!(params[:area])
    redirect_to([:admin, :areas], :notice => 'Area has been successfully updated.')
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
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
