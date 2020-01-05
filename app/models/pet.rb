class Pet < ApplicationRecord
    has_many :events
    belongs_to :user
    
    validates :name, :kind, :breed, :birthday, presence: true
    validates :name, :kind, :breed, length: { in: 1..50}
end
