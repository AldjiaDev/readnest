class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :chronicle
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true, length: { minimum: 3, maximum: 1000 }
  has_many :comment_likes, dependent: :destroy
end
