class Parking < ApplicationRecord
  validates :plate, presence: true, length: { is: 8 }, format: { with: /\A[A-Z]{3}-\d{4}\z/ }
  validates :paid, inclusion: { in: [ true, false ] }
  # attr_was a rails method to check attribute before update
  validate { errors.add(:paid, "can't be processed again") if paid_was && paid }
end
