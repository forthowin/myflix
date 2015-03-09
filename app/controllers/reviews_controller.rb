class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.new(review_params)
    review.user = current_user
    if review.save
      flash[:success] = "Thank you for your review!"
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      flash.now[:danger] = "Review can't be blank."
      render 'videos/show'
    end
    
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
