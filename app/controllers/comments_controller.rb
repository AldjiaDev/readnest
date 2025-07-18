class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle
  before_action :set_comment, only: [:destroy, :report]

  def create
    @comment = @chronicle.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      # Créer une notification pour l’auteur de la chronique (sauf si c’est l’auteur lui-même)
      if @chronicle.user != current_user
        Notification.create(
          recipient: @chronicle.user,
          actor: current_user,
          action: "commented",
          notifiable: @comment
        )
      end

      redirect_to @chronicle, notice: "Votre commentaire a été publié."
    else
      redirect_to @chronicle, alert: "Erreur lors de la publication du commentaire."
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_back fallback_location: @chronicle, notice: "Commentaire supprimé avec succès."
    else
      redirect_back fallback_location: @chronicle, alert: "Vous ne pouvez supprimer que vos propres commentaires."
    end
  end

  def report
    @comment.update(reported: true)
    redirect_back fallback_location: @chronicle, notice: "Le commentaire a été signalé."
  end

  private

  def set_chronicle
    @chronicle = Chronicle.find(params[:chronicle_id])
  end

  def set_comment
    @comment = @chronicle.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
