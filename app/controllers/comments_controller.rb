class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle

  def create
    @comment = @chronicle.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @chronicle, notice: "Commentaire publié."
    else
      redirect_to @chronicle, alert: "Erreur lors de la publication."
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to @comment.chronicle, notice: "Commentaire supprimé."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:chronicle_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
