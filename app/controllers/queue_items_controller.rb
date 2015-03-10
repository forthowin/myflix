class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.delete if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    unless video_in_queue?(video)
      QueueItem.create(video: video, user: current_user, position: new_queue_item_position)
      flash[:success] = "Video has been added to the queue."
    else
      flash[:danger] = "Video is already in queue."
    end
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def video_in_queue?(video)
    current_user.queue_items.where(video_id: video.id).first
  end

end