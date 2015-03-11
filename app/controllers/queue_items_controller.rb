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
    if current_user.queue_items.include?(queue_item)
      queue_item.delete 
      normalize_queue_item_positions
    end
    
    redirect_to my_queue_path
  end

  def queue_update
    begin
      update_queue_item_positions
      normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid order number."
    end

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

  def update_queue_item_positions
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position]) if queue_item.user == current_user
      end
    end
  end

  def normalize_queue_item_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

end