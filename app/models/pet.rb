class Pet < ApplicationRecord
    validates :name, :kind, :breed, :birthday, presence: true
    validates :name, :kind, :breed, length: { in: 1..50}
end
