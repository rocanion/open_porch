class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  before_filter :build_address, :only => [:new, :index, :create]
  
  def index
    # ...
  end
  
  def new
    # ...
  end
  
  def create
    if @address.valid?
      @areas = @address.closest_regions
      @selected_area = @areas.shift
      @address.area_id = @selected_area.id
      
      @user = User.new(:address_attributes => @address)
      @user.memberships.build(:area_id => @selected_area.id)
    else
      render :action => :index
    end
  end
  
  
protected
  def build_address
    @address = Address.new(params[:address])
  end

end
