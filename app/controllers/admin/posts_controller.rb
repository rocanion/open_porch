class Admin::PostsController < Admin::BaseController
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
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
end
