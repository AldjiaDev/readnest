class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  # Relations principales
  has_many :chronicles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_chronicles, through: :likes, source: :chronicle

  # Notifications
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :nullify

  # Follows
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :follows, source: :followable, source_type: "User"
  has_many :followed_publishers, through: :follows, source: :followable, source_type: "PublishingHouse"
  has_many :followed_bookshops, through: :follows, source: :followable, source_type: "Bookshop"

  has_many :reverse_follows, as: :followable, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower

  # Messagerie
  has_many :sent_conversations, class_name: "Conversation", foreign_key: "sender_id", dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: "receiver_id", dependent: :destroy
  has_many :messages, dependent: :destroy

  # Comment likes
  has_many :comment_likes, dependent: :destroy
  has_many :liked_by_users, through: :comment_likes, source: :user

  # Maison d’édition
  has_one :publishing_house, dependent: :destroy

  # Librairie
  has_one :bookshop, dependent: :destroy

  # Création automatique si case cochée
  after_commit :create_publishing_house_if_needed, on: :create
  after_commit :create_bookshop_if_needed, on: :create

  def create_publishing_house_if_needed
    return unless is_publishing_house?

    create_publishing_house!(
      name: username,
      description: "Maison d’édition de #{username}"
    )
  end

  def create_bookshop_if_needed
    return unless is_bookshop?

    create_bookshop!(
      name: username,
      description: "Librairie #{username}"
    )
  end

  # Vérifie les colonnes booleans directement
  def is_publishing_house?
    self[:is_publishing_house]
  end

  def is_bookshop?
    self[:is_bookshop]
  end

  # Vérifie si l’utilisateur suit déjà un enregistrement
  def following?(record)
    follows.exists?(followable: record)
  end

  # Recherche (pg_search)
  include PgSearch::Model
  pg_search_scope :search_by_username_and_bio,
                  against: [:username, :bio],
                  using: {
                    tsearch: { prefix: true },
                    trigram: {}
                  }

  # FriendlyId
  extend FriendlyId
  friendly_id :username, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_username?
  end
end
