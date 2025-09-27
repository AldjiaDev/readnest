class PublishingHousesController < ApplicationController
  before_action :set_publishing_house, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @publishing_houses = PublishingHouse.all.order(created_at: :desc)
  end

  def show
    @publishing_house = PublishingHouse.friendly.find(params[:id])

    prepare_meta_tags(
      title: @publishing_house.name,
      description: @publishing_house.description.presence || "Maison d’édition sur Readnest",
      image: @publishing_house.logo.attached? ? url_for(@publishing_house.logo) : view_context.asset_url("logo.jpg")
    )
  end

  def new
    @publishing_house = PublishingHouse.new
  end

  def create
    @publishing_house = current_user.build_publishing_house(publishing_house_params)

    if @publishing_house.save
      redirect_to @publishing_house, notice: "Maison d’édition créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @publishing_house.update(publishing_house_params)
      redirect_to @publishing_house, notice: "Maison d’édition mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @publishing_house.destroy
    redirect_to publishing_houses_path, status: :see_other, notice: "Maison d’édition supprimée."
  end

  private

  def set_publishing_house
    @publishing_house = PublishingHouse.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to publishing_houses_path, alert: "Maison d’édition introuvable."
  end

  def authorize_user!
    unless @publishing_house.user == current_user
      redirect_to publishing_houses_path, alert: "Accès refusé."
    end
  end

  def publishing_house_params
    params.require(:publishing_house).permit(:name, :description, :logo)
  end
end
