class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
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
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_back fallback_location: root_path, notice: "Commentaire supprimé."
    else
      redirect_back fallback_location: root_path, alert: "Action non autorisée."
    end
  end

  def report
    @comment = Comment.find(params[:id])
    @comment.update(reported: true)
    redirect_back fallback_location: root_path, notice: "Le commentaire a été signalé."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:chronicle_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
