class Area::PostsController < Area::BaseController
  before_filter :build_post,
    :only => [:new, :create]
  
  def index
    params[:search] ||= {}
    @search = @area.posts.order('created_at DESC').joins(:issue).where('sent_at IS NOT NULL').search(params[:search])
    @posts = @search.paginate(:page => params[:page])
  end
  
  def new
  end
  
  def create
    @post.save!
    redirect_to(area_path(@area), :notice => 'Your message has been successfully posted.')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end

protected
  
  def build_post
    @post = @area.posts.new(params[:post])
    @post.user = current_user
  end
  
end
