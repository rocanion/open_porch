class SessionsController < ApplicationController
  before_filter :login_required,  :only => :destroy
  before_filter :redirect_if_logged_in, :only => [ :new, :create ]
  before_filter :build_user_session,  :only => [ :new, :create ]
  
  def create
    if @session_user.save
      login(@session_user)
      redirect_to(user_path(current_user), :notice => "Welcome, you are now logged in.")
    else
      flash[:alert] = 'Login failed. Did you mistype?'
      render :action => :new
    end
  end
  
  def destroy
    logout
    redirect_to login_path
  end
  
protected
  def build_user_session
    @session_user = SessionUser.new(params[:session_user])
  end
  
  def redirect_if_logged_in
    redirect_to user_path(current_user) if logged_in?
  end
  
  def login_required
    redirect_to login_path unless logged_in?
  end
end
