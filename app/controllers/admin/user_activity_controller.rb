class Admin::UserActivityController < Admin::BaseController
  before_filter :require_authority_to_manage_areas
  before_filter :load_user_activity
  
  def index
  end
  
  def show
    @user_activities = UserActivity.active_for_page(current_user.full_name, params[:url])
    render :layout => false, :object => @user_activities
  rescue ActiveRecord::RecordInvalid
    head :bad_request
  end
  
  def edit
  end
  
  def update
    @user_activity.set_expiration!
    render :nothing => true
  end
  
protected
  
  def load_user_activity
    @user_activity = UserActivity.find_or_create_by_name_and_url(:name => current_user.full_name, :url => params[:url])
  end
  
end