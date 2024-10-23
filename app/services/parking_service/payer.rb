class ParkingService::Payer
  def initialize(parking_payment_params)
    @id = parking_payment_params[:id]
  end

  def call
    parking = Parking.find(@id)
    parking.update!(paid: true)
    parking
  end
end
