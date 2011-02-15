class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create, :verify_email, :resend_email_verification]
  before_filter :redirect_if_logged_in, :only => [ :new, :create, :verify_email, :resend_email_verification ]
  before_filter :build_user, :only => [:new, :create]
  before_filter :load_user, :only => [:edit, :update]
  
  def new
    # ...
  end
  
  def create
    @user.set_email_verification_key
    @user.save!
    UserMailer::email_verification(@user).deliver
    redirect_to root_path, :notice => "Thank you, please check your email to complete the registration."
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end
  
  def edit; end
  
  def update
    @user.update_attributes!(params[:user])
    redirect_to(user_path, :notice => 'Your profile has been updated')
  rescue ActiveRecord::RecordInvalid
    render :action => :edit
  end
  
  def verify_email
    if @user = User.where(:email_verification_key => params[:email_verification_key]).first
      @user.update_attributes(
        :verified_at => Time.now,
        :email_verification_key => nil
      )
      flash[:notice] = "Your email address has been verified. You can now login"
      redirect_to login_path
    else
      flash[:alert] = "We were not able to verify your account. Please contact us for assistance."
      redirect_to root_path
    end
  end
  
  def resend_email_verification
    if @user = User.where(:email_verification_key => params[:email_verification_key]).first
      # Just ignore it if the user is already verified
      if @user.is_verified?
        flash[:notice] = "Your account has already been validated. You can now login."
      else
        UserMailer::email_verification(@user).deliver
        flash[:notice] = "The email verification has been sent to #{@user.email}"
      end
    end
    redirect_to login_path
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