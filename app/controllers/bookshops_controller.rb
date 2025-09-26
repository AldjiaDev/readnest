class BookshopsController < ApplicationController
  before_action :set_bookshop, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @bookshops = Bookshop.all.order(created_at: :desc)
  end
  def show
  end
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

  def edit
  end

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

  def follow
    @bookshop = Bookshop.friendly.find(params[:id])
    current_user.follows.create(followable: @bookshop)
    redirect_to @bookshop, notice: "Vous suivez maintenant cette librairie."
  end

  def unfollow
    @bookshop = Bookshop.friendly.find(params[:id])
    current_user.follows.find_by(followable: @bookshop)&.destroy
    redirect_to @bookshop, notice: "Vous ne suivez plus cette librairie."
  end

  private

  def set_bookshop
    @bookshop = Bookshop.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to bookshops_path, alert: "Librairie introuvable."
  end

  def authorize_user!
    unless @bookshop.user == current_user
      redirect_to bookshops_path, alert: "Accès refusé."
    end
  end

  def bookshop_params
    params.require(:bookshop).permit(:name, :description, :logo)
  end
end
