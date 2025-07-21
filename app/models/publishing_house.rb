
class PublishingHouse < ApplicationRecord
  belongs_to :user
  has_one_attached :logo
  has_many :chronicles, dependent: :nullify

  has_many :follows, as: :followable, dependent: :destroy
  has_one_attached :logo
end
