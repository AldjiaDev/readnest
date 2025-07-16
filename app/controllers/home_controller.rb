class HomeController < ApplicationController
  def index
    @chronicles = Chronicle.order(created_at: :desc).limit(6)
  end
end
