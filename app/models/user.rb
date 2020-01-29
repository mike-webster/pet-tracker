class User < ApplicationRecord
  has_many :pets
  has_secure_password

  validates :first_name, :last_name, :email, :timezone, presence: true
  validates :first_name, :last_name, length: { in: 1..50}
  validates :email, length: { in: 5..200 }
  validates :password, length: { in: 10..500 }, on: :create
  validate :timezone_not_default

  def timezone_not_default
    return if timezone != "Select timezone"
    errors.add(:timezone, "please select a timezone")
  end

end
