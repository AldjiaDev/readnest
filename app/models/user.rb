class User < ApplicationRecord
  # === Authentification ===
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # === Fichiers attachés ===
  has_one_attached :avatar

  # === Relations principales ===
  has_many :chronicles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_chronicles, through: :likes, source: :chronicle

  # === Notifications ===
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :nullify

  # === Follows ===
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :follows, source: :followable, source_type: "User"
  has_many :followed_publishers, through: :follows, source: :followable, source_type: "PublishingHouse"
  has_many :followed_bookshops, through: :follows, source: :followable, source_type: "Bookshop"

  has_many :reverse_follows, as: :followable, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower

  # === Messagerie ===
  has_many :sent_conversations, class_name: "Conversation", foreign_key: "sender_id", dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: "receiver_id", dependent: :destroy
  has_many :messages, dependent: :destroy

  # === Comment Likes ===
  has_many :comment_likes, dependent: :destroy
  has_many :liked_by_users, through: :comment_likes, source: :user

  # === Entités spéciales ===
  has_one :publishing_house, dependent: :destroy
  has_one :bookshop, dependent: :destroy

  # === Favoris ===
  has_many :favorites, dependent: :destroy
  has_many :favorite_chronicles, through: :favorites, source: :chronicle

  # === Création automatique après inscription (corrigée pour Devise/Heroku) ===
  after_create :create_special_entities

  def create_special_entities
    create_publishing_house_if_needed
    create_bookshop_if_needed
  end

  def create_publishing_house_if_needed
    return unless is_publishing_house? && publishing_house.blank?

    PublishingHouse.create!(
      user: self,
      name: username,
      description: "Maison d’édition de #{username}"
    )
  end

  def create_bookshop_if_needed
    return unless is_bookshop? && bookshop.blank?

    Bookshop.create!(
      user: self,
      name: username,
      description: "Librairie #{username}"
    )
  end

  # === États de compte ===
  def is_publishing_house?
    self[:is_publishing_house]
  end

  def is_bookshop?
    self[:is_bookshop]
  end

  def is_author?
    self[:is_author]
  end

  # === Rôles & affichage ===
  def role_name
    if is_author?
      "Auteur·ice"
    elsif is_publishing_house?
      "Maison d’édition"
    elsif is_bookshop?
      "Librairie"
    else
      "Lecteur·rice"
    end
  end

  def can_publish_chronicles?
    is_author? || is_publishing_house?
  end

  # === Avatar par défaut ===
  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    else
      ActionController::Base.helpers.asset_path("default_avatar.png")
    end
  end

  # === Follows utilitaires ===
  def following?(record)
    follows.exists?(followable: record)
  end

  # === Recherche (pg_search) ===
  include PgSearch::Model
  pg_search_scope :search_by_username_and_bio,
                  against: [:username, :bio],
                  using: {
                    tsearch: { prefix: true },
                    trigram: {}
                  }

  # === FriendlyId ===
  extend FriendlyId
  friendly_id :username, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_username?
  end
end
