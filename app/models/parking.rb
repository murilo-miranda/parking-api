class Parking < ApplicationRecord
  validate :paying_twice, on: :update

  validates :plate, presence: true, length: { is: 8 }, format: { with: /\A[A-Z]{3}-\d{4}\z/ }
  validates :paid, inclusion: { in: [ true, false ] }
  # attr_was a rails method to check attribute before update
  validate { errors.add(:exit_time, "can't leave without paying") if !paid && exit_time_changed? }

  def paying_twice
    if paid_came_from_user? && paid_was
      errors.add(:paid, "can't be processed again")
    end
  end
end
