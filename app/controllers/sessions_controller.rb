class SessionsController < ApplicationController
  skip_before_filter :login_required,  :except => :destroy
  before_filter :redirect_if_logged_in, :only => [ :new, :create ]
  before_filter :build_user_session,  :only => [ :new, :create ]
  
  def create
    if @session_user.save
      login(@session_user)
      redirect_to(area_path(current_user.areas.first), :notice => "Welcome, you are now logged in.")
    else
      flash.now[:alert] = 'Login failed. Did you mistype?'
      render :action => :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
  
protected
  def build_user_session
    @session_user = SessionUser.new(params[:session_user])
  end
  
  def redirect_if_logged_in
    redirect_to user_path if logged_in?
  end
end
