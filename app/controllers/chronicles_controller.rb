class ChroniclesController < ApplicationController
  before_action :set_chronicle, only: %i[ show edit update destroy ]

  # GET /chronicles or /chronicles.json
  def index
    @chronicles = Chronicle.all
  end

  # GET /chronicles/1 or /chronicles/1.json
  def show
  end

  # GET /chronicles/new
  def new
    @chronicle = Chronicle.new
  end

  # GET /chronicles/1/edit
  def edit
  end

  # POST /chronicles or /chronicles.json
def create
  @chronicle = current_user.chronicles.build(chronicle_params)

  if @chronicle.save
    redirect_to @chronicle, notice: "Chronicle was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /chronicles/1 or /chronicles/1.json
  def update
    respond_to do |format|
      if @chronicle.update(chronicle_params)
        format.html { redirect_to @chronicle, notice: "Chronicle was successfully updated." }
        format.json { render :show, status: :ok, location: @chronicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chronicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chronicles/1 or /chronicles/1.json
  def destroy
    @chronicle.destroy!

    respond_to do |format|
      format.html { redirect_to chronicles_path, status: :see_other, notice: "Chronicle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def chronicle_params
    params.require(:chronicle).permit(:title, :content, :photo)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chronicle
      @chronicle = Chronicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chronicle_params
      params.require(:chronicle).permit(:title, :content, :user_id)
    end
end
