class AuthorsController < ApplicationController
  def index
    @authors =
      User.where(is_author: true)
          .order(created_at: :desc)
          .includes(:avatar_attachment)
  end

  def show
    @author = User.find(params[:id])

    unless @author.is_author?
      redirect_to authors_path, alert: "Cet utilisateur n’est pas un·e auteur·rice."
      return
    end

    @chronicles = Chronicle.where(user_id: @author.id).order(created_at: :desc)
  end
end
