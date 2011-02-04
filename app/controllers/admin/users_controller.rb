class Admin::UsersController < Admin::BaseController
  before_filter :load_user,
    :except => [:index]
  
  def index
    @users = User.all
  end
  
  def edit
  end
  
  def update
    @user.send(:attributes=, params[:user], false)
    @user.save!
    redirect_to(@return_url, :notice => 'User has been successfully updated.')
  rescue ActiveRecord::RecordInvalid
   render :action => :edit
  end
  
  def destroy
    @user.destroy
    redirect_to([:admin, :users], :notice => 'User has been successfully deleted.')
  end
  
protected
  def load_user
    @user = User.find(params[:id])
    if params[:area_id]
      @return_url = admin_area_memberships_path(params[:area_id])
    else
      @return_url = admin_users_path
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'User not found', :status => 404
  end
end
