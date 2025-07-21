class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  has_many :chronicles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_chronicles, through: :likes, source: :chronicle
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :nullify

    # Follows qu’il a créés
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :follows, source: :followable, source_type: 'User'
  has_many :followed_publishers, through: :follows, source: :followable, source_type: 'Publisher'

  # Follows qu’il reçoit (utilisateurs qui le suivent)
  has_many :reverse_follows, as: :followable, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower
  has_many :publishing_houses, dependent: :destroy
end
