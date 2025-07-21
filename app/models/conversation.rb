class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :receiver_id }

  scope :between, ->(sender_id, receiver_id) do
    where(sender_id: sender_id, receiver_id: receiver_id)
      .or(where(sender_id: receiver_id, receiver_id: sender_id))
  end

  def other_user(current_user)
    sender == current_user ? receiver : sender
  end

  def self.between(user1_id, user2_id)
    where(sender_id: user1_id, receiver_id: user2_id).or(
      where(sender_id: user2_id, receiver_id: user1_id)
    )
  end
end
