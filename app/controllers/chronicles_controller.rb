class ChroniclesController < ApplicationController
  before_action :set_chronicle, only: %i[ show edit update destroy ]

  def index
    @chronicles = Chronicle.all
  end

  def show
  end

  def new
    @chronicle = Chronicle.new
  end

  def edit
  end

  def create
    @chronicle = current_user.chronicles.build(chronicle_params)

    if @chronicle.save
      redirect_to @chronicle, notice: "Chronique publiée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @chronicle.update(chronicle_params)
      redirect_to @chronicle, notice: "Chronique mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chronicle.destroy!
    redirect_to chronicles_path, status: :see_other, notice: "Chronique supprimée."
  end

  private

    def set_chronicle
      @chronicle = Chronicle.find(params[:id])
    end

    def chronicle_params
      params.require(:chronicle).permit(:title, :author, :book_title, :publisher, :content, :photo)
    end
end
