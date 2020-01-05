class Pet < ApplicationRecord
    has_many :events
    
    validates :name, :kind, :breed, :birthday, presence: true
    validates :name, :kind, :breed, length: { in: 1..50}
end
