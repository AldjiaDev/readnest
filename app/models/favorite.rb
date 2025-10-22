class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :chronicle

  # Empêche qu’un utilisateur ajoute deux fois la même chronique à ses favoris
  validates :user_id, uniqueness: { scope: :chronicle_id }

  # Méthode utilitaire pour vérifier si une chronique est déjà en favori
  def self.favorited?(user, chronicle)
    exists?(user: user, chronicle: chronicle)
  end
end
