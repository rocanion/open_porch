class PasswordsController < ApplicationController
  skip_before_filter :login_required
  before_filter :redirect_if_logged_in, :only => [ :new, :create, :edit, :update ]
  before_filter :load_user_by_perishable_token, :only => [:edit, :update]
  
  def new
    # ...
  end
  
  def create
    user = User.find_by_email!(params[:email])
    user.reset_perishable_token!
    UserMailer.password_reset(user).deliver
    flash[:notice] = 'Email to reset password successfully sent.'
    redirect_to login_path
  rescue ActiveRecord::RecordNotFound
    flash.now[:alert] = 'Your email was not found. Did you mistype?'
    render :action => :new
  end
  
  def edit
    # ...
  end
  
  def update
    @user.update_attributes!(params[:user].merge(:perishable_token => nil))
    login_as_user(@user)
    flash[:notice] = 'Your password was successfully updated!'
    redirect_to user_path(@user)
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = 'An error occurred. Please try again.'
    redirect_to login_path
  end
  
  
protected
  def load_user_by_perishable_token
    @user = User.find_by_perishable_token!(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to login_path
  end
end
