class Admin::IssuesController < Admin::BaseController
  before_filter :load_area
  before_filter :load_issue,
    :except => [:index, :new]
  
  def index
    @issues = @area.issues
  end
  
  def new
    @issue = @area.issues.create!
    redirect_to edit_admin_area_issue_path(@area, @issue)
  end

  def edit
  end
  
  def update
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
end
