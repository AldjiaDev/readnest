class Chronicle < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  attribute :table_of_contents, :string, array: true, default: []

  include PgSearch::Model

  pg_search_scope :search_by_title_and_content,
    against: [:title, :content, :summary],
    using: {
      tsearch: { prefix: true }, # "liv" => "livre"
      trigram: {} # tolérance aux fautes
    }

  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title?
  end
end
