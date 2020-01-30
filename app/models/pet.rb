class Pet < ApplicationRecord
    has_many :events
    belongs_to :user
    
    validates :birthday, presence: true
    validates :name, :kind, :breed, length: { in: 1..50}
end
