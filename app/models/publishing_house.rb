
class PublishingHouse < ApplicationRecord
  belongs_to :user
  has_one_attached :logo
  has_many :chronicles, dependent: :nullify

  has_many :follows, as: :followable, dependent: :destroy
  has_one_attached :logo

    include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :name,
    using: {
      tsearch: { prefix: true },
      trigram: {}
    }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_name?
  end
end
