class HomeController < ApplicationController
  def index
    @chronicles = Chronicle.order(created_at: :desc).limit(3)
    @publishing_houses = PublishingHouse.limit(6)
  end
end
