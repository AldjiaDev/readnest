class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle, only: [:create]
  before_action :set_favorite, only: [:destroy]

  # === GET /favoris ===
  def index
    @favorites = current_user.favorites.includes(:chronicle)
  end

  # === POST /favoris ===
  def create
    @favorite = current_user.favorites.new(chronicle: @chronicle)

    if @favorite.save
      redirect_to @chronicle, notice: "💖 Cette chronique a été ajoutée à vos favoris."
    else
      redirect_to @chronicle, alert: "❌ Impossible d’ajouter cette chronique à vos favoris."
    end
  end

  # === DELETE /favoris/:id ===
  def destroy
    chronicle = @favorite.chronicle
    @favorite.destroy
    redirect_to chronicle, notice: "🗑️ Cette chronique a été retirée de vos favoris."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:chronicle_id])
  end

  def set_favorite
    @favorite = current_user.favorites.find(params[:id])
  end
end

