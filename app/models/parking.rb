class Parking < ApplicationRecord
  validates :plate, presence: true, length: { is: 8 }, format: { with: /\A[A-Z]{3}-\d{4}\z/ }
  validates :paid, inclusion: { in: [ true, false ] }
end
