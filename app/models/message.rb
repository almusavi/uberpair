class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :account

  validates_presence_of :body, :account_id

  scope :latest, -> { order(created_at: :desc).limit(1) }

end
