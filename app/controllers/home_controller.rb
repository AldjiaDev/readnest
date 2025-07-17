class HomeController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query]
      @chronicles = Chronicle.joins(:user).where(
        "chronicles.title ILIKE :q OR chronicles.content ILIKE :q OR users.username ILIKE :q",
        q: "%#{query}%"
      )
    else
      @chronicles = Chronicle.includes(:user).order(created_at: :desc)
    end
  end
end
