class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video #same as line 23
  delegate :title, to: :video, prefix: :video #same as line 10

  validates_presence_of :user, :video

  # def video_title
  #   video.title
  # end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def category_name
    category.name #don't need video.category.name because of line 5
  end

  # def category
  #   video.category
  # end

end