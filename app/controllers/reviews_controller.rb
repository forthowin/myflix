class ReviewsController < ApplicationController
  def create
    video = Video.find(params[:video_id])
    review = video.reviews.new(review_params)
    review.user = current_user
    review.save
    flash[:success] = "Thank you for your review!"
    redirect_to video_path(video)
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
