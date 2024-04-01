class HomeController < ApplicationController

  def index
    @reviews = Review.all

  end
end