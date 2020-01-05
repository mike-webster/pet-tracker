class Event < ApplicationRecord
    validates :name, :kind, :happened_at, :created_at, presence: true
    validates :kind { in: ["pee", "poo", "meal", "treat", "nap_start", "nap_end"]}
end