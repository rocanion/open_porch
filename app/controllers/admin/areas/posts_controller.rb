class Admin::Areas::PostsController < Admin::Areas::BaseController
  respond_to :js
  before_filter :load_post,
    :except => :order
  
  def edit
  end
  
  def update
    @post.update_attributes(params[:post])
  end
  
  def show
  end
  
  def order
    if params[:post].present?
      params[:post].each_with_index do |post, i|
        Post.update_all(['position = %d', i], ['id = %d', post])
      end
    end
    render :nothing => true
  end
  
  def toggle_reviewed_by
    if !@post.reviewed_by
      @post.update_attribute(:reviewed_by, current_user.full_name)
    else
      @post.update_attribute(:reviewed_by, nil)
    end
    render :layout => false
  end

protected
  def load_post
    @post = @area.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
end
