class ChroniclesController < ApplicationController
  before_action :set_chronicle, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @chronicles = Chronicle.all
  end

  def show
  end

  def new
    @chronicle = Chronicle.new
  end

  def create
    @chronicle = current_user.chronicles.build(chronicle_params)

    if @chronicle.save
      redirect_to @chronicle, notice: "Chronique publiée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @chronicle = Chronicle.find(params[:id])
    redirect_to root_path, alert: "Non autorisé" unless @chronicle.user == current_user
  end

  def update
    @chronicle = Chronicle.find(params[:id])
    if @chronicle.user == current_user
      if @chronicle.update(chronicle_params)
        redirect_to @chronicle, notice: "Chronique mise à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "Non autorisé"
    end
  end

  def destroy
    @chronicle.destroy
    redirect_to chronicles_path, status: :see_other, notice: "Chronique supprimée."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:id])
  end

  def authorize_owner!
    unless @chronicle.user == current_user
      redirect_to chronicles_path, alert: "Vous n’êtes pas autorisé à effectuer cette action."
    end
  end

  def chronicle_params
    params.require(:chronicle).permit(:title, :content, :photo, :caption, :summary, :book_title, :author, :publisher, table_of_contents: [])
  end
end
