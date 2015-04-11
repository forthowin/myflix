class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_param)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "Unable to add video. Please check the error messages."
      render :new
    end
  end

  private

  def video_param
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover)
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You are not authorized to do that."
      redirect_to home_path
    end
  end  
end