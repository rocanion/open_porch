class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  before_filter :redirect_if_logged_in, :only => [ :new, :create ]
  before_filter :build_user, :only => [:new, :create]
  before_filter :load_user, :only => [:edit, :update]
  
  def new
    # ...
  end
  
  def create
    @user.save!
    login_as_user(@user)
    redirect_to(area_path(current_user.areas.first), :notice => "Welcome, you are now logged in.")
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def edit
  end
  
  def update
    @user.update_attributes!(params[:user])
    redirect_to(user_path, :notice => 'Your profile has been updated')
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end
  
  
protected
  def build_user
    @user = User.new(params[:user])
    if @user.memberships.empty?
      redirect_to root_path
    else
      @area = @user.memberships.first.area
    end
  end
  
  def load_user
    @user = current_user
  end
  
end