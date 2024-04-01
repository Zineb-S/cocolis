class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.new(review_params)
    @review.driver_id = @review.delivery.driver_id  # Assigning driver_id based on delivery

    if @review.save
      redirect_to client_messages_path, notice: 'Review was successfully created.'
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:client_id, :driver_id, :delivery_id, :timeliness, :communication, :handling, :comment)
  end
end
