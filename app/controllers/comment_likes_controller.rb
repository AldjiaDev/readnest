class CommentLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def create
    unless @comment.comment_likes.exists?(user: current_user)
      @comment.comment_likes.create(user: current_user)
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    like = @comment.comment_likes.find_by(user: current_user)
    like&.destroy
    redirect_back fallback_location: root_path
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
