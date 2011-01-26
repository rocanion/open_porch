class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  before_filter :build_user, :only => [:new, :create]
  
  def new
    @area = @user.memberships.first.area
  end
  
  def create
    @area = @user.memberships.first.area
    @user.save!
    login_as_user(@user)
    redirect_to(@user, :notice => 'Welcome')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  
protected
  def build_user
    @user = User.new(params[:user])
  end
  
end