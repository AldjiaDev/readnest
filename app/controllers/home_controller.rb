class HomeController < ApplicationController
  def index
    @chronicles = Chronicle.order(created_at: :desc).limit(3)
    @publishing_houses = PublishingHouse.order(created_at: :desc).limit(6)
    @bookshops = Bookshop.order(created_at: :desc).limit(6)
  end
end
