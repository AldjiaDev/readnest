class BookshopsController < ApplicationController
  before_action :set_bookshop, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show map]
  before_action :authorize_user!, only: %i[edit update destroy]

  # Toutes les librairies inscrites sur Readnest
  def index
    @bookshops = Bookshop.all.order(created_at: :desc)
  end

  # Librairies autour de moi (affichées sur la carte)
  def map
    if params[:latitude].present? && params[:longitude].present?
      @bookshops = Bookshop.near([params[:latitude], params[:longitude]], 50)
    else
      @bookshops = Bookshop.all
    end
  end

  def show; end

  def new
    @bookshop = Bookshop.new
  end

  def create
    @bookshop = current_user.build_bookshop(bookshop_params)
    if @bookshop.save
      redirect_to edit_bookshop_path(@bookshop), notice: "Librairie créée avec succès. Complétez vos informations !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @bookshop.update(bookshop_params)
      redirect_to @bookshop, notice: "Librairie mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bookshop.destroy
    redirect_to bookshops_path, status: :see_other, notice: "Librairie supprimée."
  end

  private

  def set_bookshop
    @bookshop = Bookshop.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to bookshops_path, alert: "Librairie introuvable."
  end

  def authorize_user!
    redirect_to bookshops_path, alert: "Accès refusé." unless @bookshop.user == current_user
  end

  def bookshop_params
    params.require(:bookshop).permit(:name, :description, :logo, :address, :latitude, :longitude)
  end
end
