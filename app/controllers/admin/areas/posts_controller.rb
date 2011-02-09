class Admin::Areas::PostsController < Admin::Areas::BaseController
  respond_to :js
  before_filter :load_post,
    :except => :order
  
  def edit
  end
  
  def update
    @post.reviewed_by = current_user
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

protected
  def load_post
    @post = @area.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
end
