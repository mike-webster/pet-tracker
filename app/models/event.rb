class Event < ApplicationRecord
  EVENT_OPTIONS = %w(pee poo meal treat sleep_start sleep_end)

  validates :kind, :happened_at, :created_at, presence: true
  validates :kind, inclusion: { in: EVENT_OPTIONS}

  belongs_to :pet

  scope :for_user, -> (user_id) { joins(:pet).where("pets.user_id = ?", user_id)}
end