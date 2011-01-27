class PostsController < ApplicationController
  before_filter :load_area
  before_filter :build_post
  
  def new
  end
  
  def create
    @post.save!
    redirect_to(area_path(@area), :notice => 'Your message has been successfully posted.')
  rescue ActiveRecord::RecordInvalid
    render :action => :new
  end

protected

  def load_area
    @area = current_user.areas.find(params[:area_id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'Area not found', :status => 404
  end
  
  def build_post
    @post = @area.posts.new(params[:post])
    @post.user = current_user
  end
  
end
