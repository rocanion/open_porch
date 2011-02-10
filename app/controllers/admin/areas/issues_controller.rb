class Admin::Areas::IssuesController < Admin::Areas::BaseController
  before_filter :load_issue,
    :except => [:index, :new]
  before_filter :block_edit_if_sent,
    :except => [:index, :new, :show]
  
  def index
    @issues = @area.issues
    
  end
  
  def new
    @issue = @area.issues.create!
    redirect_to edit_admin_area_issue_path(@area, @issue)
  end

  def edit
    load_posts
  end
  
  def show
  end
  
  def update
    @issue.update_attributes!(params[:issue])
    redirect_to edit_admin_area_issue_path(@area, @issue)
  rescue ActiveRecord::RecordInvalid
    load_posts
    render :action => :edit
  end

  def add_posts
    return if params[:posts].blank?
    Post.update_all(['issue_id = %d', @issue.id], ['id IN (?)', params[:posts]])
  end

  def remove_posts
    return if params[:posts].blank?
    Post.update_all('issue_id = NULL', ['id IN (?)', params[:posts]])
  end
  
protected
  def load_area
    @area = Area.find(params[:area_id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found.', :status => 404
  end

  def load_issue
    @issue = @area.issues.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Issue not found.', :status => 404
  end
  
  def load_posts
    @new_posts = @area.posts.in_issue(nil).order('created_at DESC')
    @issue_posts = @area.posts.in_issue(@issue).order('position')
  end
  
  def block_edit_if_sent
    if @issue.sent_at.present?
      redirect_to admin_area_issue_path(@area, @issue) 
    end
  end
end
