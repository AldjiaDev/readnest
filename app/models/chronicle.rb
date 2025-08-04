class Chronicle < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  attribute :table_of_contents, :string, array: true, default: []
end
