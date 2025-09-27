class ChroniclesController < ApplicationController
  before_action :set_chronicle, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @chronicles = Chronicle.all.order(created_at: :desc)
  end

  def show
    @chronicle = Chronicle.friendly.find(params[:id])

    prepare_meta_tags(
      title: @chronicle.title,
      description: @chronicle.summary.presence || @chronicle.content.truncate(150),
      image: @chronicle.photo.attached? ? url_for(@chronicle.photo) : view_context.asset_url("logo.jpg")
    )
  end

  def new
    @chronicle = Chronicle.new
  end

  def create
    @chronicle = current_user.chronicles.build(chronicle_params)
    if @chronicle.save
      redirect_to @chronicle, notice: "Chronique créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @chronicle.update(chronicle_params)
      redirect_to @chronicle, notice: "Chronique mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chronicle.destroy
    redirect_to chronicles_path, status: :see_other, notice: "Chronique supprimée."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to chronicles_path, alert: "Chronique introuvable."
  end

  def authorize_user!
    unless @chronicle.user == current_user
      redirect_to chronicles_path, alert: "Accès refusé."
    end
  end

  def chronicle_params
    params.require(:chronicle).permit(:title, :summary, :content, :photo, :caption, table_of_contents: [])
  end
end
