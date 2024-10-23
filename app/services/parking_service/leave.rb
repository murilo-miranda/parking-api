class ParkingService::Leave
  def initialize(parking_payment_params)
    @id = parking_payment_params[:id]
  end

  def call
    parking = Parking.find(@id)
    parking.update!(left: true, exit_time: DateTime.now)
    parking
  end
end
