class User < ApplicationRecord
  has_many :pets

  validates :first_name, :last_name, :email, :pass_hash, presence: true
  validates :first_name, :last_name, length: { in: 1..50}
  validates :email, length: { in: 5..200 }
  validates :pass_hash, length: { in: 10..500 }
end
