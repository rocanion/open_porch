class Admin::UsersController < Admin::BaseController
  before_filter :require_authority_to_manage_users
  before_filter :load_user,
    :except => [:index, :new, :create]
  before_filter :build_user,
    :only => [:new, :create]
  
  def index
    params[:search] ||= {}
    params[:search][:meta_sort] ||= 'created_at.desc'
    @search = User.search(params[:search])
    @users = @search.paginate(:page => params[:page])
  end
  
  def new
    @user.memberships.build
  end
  
  def create
    @user.save!
    redirect_to(admin_users_path, :notice => 'User was successfully created.')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
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
  
  def build_user
    @user = User.new(params[:user])
  end
end
