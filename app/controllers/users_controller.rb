class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  before_filter :redirect_if_logged_in, :only => [ :new, :create ]
  before_filter :build_user, :only => [:new, :create]
  
  def new
    # ...
  end
  
  def create
    @user.save!
    login_as_user(@user)
    redirect_to(@user, :notice => 'Welcome')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
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
  
  def redirect_if_logged_in
    redirect_to user_path(current_user) if logged_in?
  end
  
end