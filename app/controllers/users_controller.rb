class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  include GeoKit::Geocoders
  
  def new
    session[:user_params] ||= {}
    @user = User.new(session[:user_params])
    @user.current_registration_step = session[:registration_step] || 1
    
    @map_center = MultiGeocoder.geocode('69.165.169.78')
  end
  
  def create
    session[:user_params].deep_merge!(params[:user]) if params[:user]
    @user = User.new(session[:user_params])
    @user.role = 'regular_user'
    @user.current_registration_step = session[:registration_step] || 1
    
    if @user.valid?
      if params[:back_button]
        @user.prev_registration_step
      elsif @user.last_registration_step?
        @user.save!
        login_as_user(@user)
      else
        @user.next_registration_step
      end
    end
    
    if @user.new_record?
      session[:registration_step] = @user.current_registration_step
      render :new
    else
      session[:registration_step] = session[:user_params] = nil
      redirect_to(@user, :notice => 'Welcome')
    end
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def map
    @location = MultiGeocoder.geocode('69.165.169.78')
    point = Point.new()
    point.set_x_y(@location.lat, @location.lng)
    raise point.to_yaml
    @areas = Area.closest_from(point, 400)
  end
  
protected
  def build_user
    @user = User.new(params[:user])
  end
  
end