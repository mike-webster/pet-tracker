class Event < ApplicationRecord
  EVENT_OPTIONS = %w(pee poo meal treat sleep_start sleep_end)

  validates :kind, :happened_at, :created_at, presence: true
  validates :kind, inclusion: { in: EVENT_OPTIONS}

  belongs_to :pet

  scope :for_user, -> (user_id) { joins(:pet).where("pets.user_id = ?", user_id)}
  scope :for_pet, -> (pet_id) { where("pet_id = ?", pet_id) }
  scope :in_time_range, -> (start_time, end_time) { where("happened_at >= ? && happened_at <= ?", start_time, end_time) }
  scope :default_time_range, -> { where("happened_at >= ? && happened_at <= ?", Time.now.utc - 3.days, Time.now.utc) }
  scope :poops, -> { where("kind = 'poo'") }
  scope :pees, -> { where("kind = 'pee'") }

  attr_accessor :local_time
end