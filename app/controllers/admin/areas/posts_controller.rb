class Admin::Areas::PostsController < Admin::Areas::BaseController
  respond_to :js
  before_filter :load_post
  
  def edit
  end
  
  def update
    @post.update_attributes(params[:post])
  end
  
  def show
  end

protected
  def load_post
    @post = @area.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
end
