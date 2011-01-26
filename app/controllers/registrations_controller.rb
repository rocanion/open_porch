class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  before_filter :build_address, :only => [:new, :index, :create]
  
  def index
    @address.current_step = 0
  end
  
  def new
    @address.current_step = 0
  end
  
  def create
    
    if @address.valid?
      @address.next_step
      
      @areas = @address.closest_regions
      
      @selected_area = @areas.shift
      @user = User.new(
        :address => @address.address,
        :city => @address.city,
        :state => @address.state,
        :area_id => @selected_area.id
      )
    else
      render :action => :index
    end
  end
  
  
protected
  def build_address
    @address = Address.new(params[:address])
  end

end
