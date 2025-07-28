class PublishingHousesController < ApplicationController
  before_action :set_publishing_house, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]

  # GET /publishing_houses
  def index
    @publishing_houses = PublishingHouse.all
  end

  # GET /publishing_houses/1
  def show
  end

  # GET /publishing_houses/new
  def new
    @publishing_house = PublishingHouse.new
  end

  # GET /publishing_houses/1/edit
  def edit
  end

  # POST /publishing_houses
  def create
    @publishing_house = PublishingHouse.new(publishing_house_params)
    @publishing_house.user = current_user

    if @publishing_house.save
      redirect_to @publishing_house, notice: "Maison d’édition créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /publishing_houses/1
  def update
    if @publishing_house.update(publishing_house_params)
      redirect_to @publishing_house, notice: "Maison d’édition mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /publishing_houses/1
  def destroy
    @publishing_house.destroy
    redirect_to publishing_houses_path, status: :see_other, notice: "Maison d’édition supprimée."
  end

  private

  def set_publishing_house
    @publishing_house = PublishingHouse.find(params[:id])
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
