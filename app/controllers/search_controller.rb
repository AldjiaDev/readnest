class SearchController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query]

      # Résultats combinés
      @results = []

      @results += Chronicle.where("title ILIKE ?", "%#{query}%")
      @results += User.where("username ILIKE ?", "%#{query}%")
      @results += PublishingHouse.where("name ILIKE ?", "%#{query}%")
    else
      @results = []
    end
  end
end
