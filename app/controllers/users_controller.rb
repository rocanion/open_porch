class UsersController < ApplicationController
  before_filter :login_required
  
protected
  def login_required
    redirect_to login_path unless logged_in?
  end

end