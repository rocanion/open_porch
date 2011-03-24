class Admin::AreasController < Admin::BaseController
  before_filter :require_authority_to_manage_areas
  before_filter :build_area,
    :only => [:new, :create]
  before_filter :load_area,
    :except => [:index, :new, :create, :edit_borders, :bulk_update]
    
  def index
    params[:search] ||= {}
    params[:search][:meta_sort] ||= 'city'
    @search = Area.search(params[:search])
    @areas = @search.paginate(:page => params[:page])
    @new_posts = Area.newposts_count
    
    start_date =  Time.parse(params[:activity_start_date]).to_date    rescue 30.days.ago.to_date
    end_date =    Time.parse(params[:activity_end_date]).to_date      rescue Date.today
    
    @activities = AreaActivity.grouped_by_day.search(:day_between => [start_date, end_date]).where(:area_id => @search.all.collect(&:id))
  end
  
  def new
  end
  
  def create
    @area.save!
    respond_to do |format|
      format.html do
        redirect_to([:admin, :areas], :notice => 'Area has been successfully created.')
      end
      format.js do
        render :text => @area.id
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def show
    redirect_to [:edit, :admin, @area, @area.issues.last]
  end
  
  def edit
    # ...
  end
  
  def edit_borders
    @areas = Area.all
    @area = @selected_area = @areas.detect{|area| area.id == params[:id].to_i}
    if @selected_area.nil?
      @default_area = @areas.first
    end
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
    render :nothing => true
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
