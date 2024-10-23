class ParkingService::Creator
  def initialize(parking_params)
    @plate = parking_params[:plate]
  end

  def call
    parking = Parking.new(plate: @plate, entry_time: DateTime.now)
    parking.save!
    parking
  end
end
