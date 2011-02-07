class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  before_filter :redirect_if_logged_in
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
      if @areas.empty?
        flash[:alert] = "Sorry, we couldn't find any neighbourhoods close to you!"
        render :action => :new
      else
        @selected_area = @areas.shift
        @address.area_id = @selected_area.id
      
        @user = User.new(:address_attributes => @address)
        @user.memberships.build(:area_id => @selected_area.id)
      end
    else
      flash[:alert] = "Please enter a valid address"
      redirect_to root_path
    end
  rescue ActiveRecord::StatementInvalid
    flash[:alert] = "Sorry, we couldn't find the address you specified"
    render :action => :new
  end
  
  
protected
  def build_address
    @address = Address.new(params[:address])
  end

end
