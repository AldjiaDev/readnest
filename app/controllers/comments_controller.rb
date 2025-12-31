class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chronicle, only: [:create, :destroy, :report]
  before_action :set_comment, only: [:destroy, :report]

  def create
    @comment = @chronicle.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      # Notification au propriétaire de la chronique
      Notification.create(
        recipient: @chronicle.user,
        actor: current_user,
        action: "commented",
        notifiable: @comment
      )

      # Notification au parent si c'est une réponse
      if @comment.parent && @comment.parent.user != current_user
        Notification.create(
          recipient: @comment.parent.user,
          actor: current_user,
          action: "replied",
          notifiable: @comment
        )
      end

      redirect_to @chronicle, notice: @comment.parent ? "Réponse publiée." : "Commentaire publié."
    else
      render "chronicles/show", status: :unprocessable_entity
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
    @chronicle = Chronicle.friendly.find(params[:chronicle_slug])
  end

  def set_comment
    @comment = @chronicle.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
