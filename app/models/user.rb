class User < ApplicationRecord
  has_many :pets
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :first_name, :last_name, length: { in: 1..50}
  validates :email, length: { in: 5..200 }
  validates :password, length: { in: 10..500 }, on: :create

end
