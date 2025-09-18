class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :chronicle

  # Hiérarchie (réponses aux commentaires)
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  # Likes
  has_many :comment_likes, dependent: :destroy
  has_many :liked_by_users, through: :comment_likes, source: :user

  # Validation
  validates :content, presence: true, length: { minimum: 3, maximum: 1000 }
end
