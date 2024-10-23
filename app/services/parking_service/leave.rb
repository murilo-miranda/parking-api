class ParkingService::Leave
  def initialize(parking_leave_params)
    @id = parking_leave_params[:id]
  end

  def call
    parking = Parking.find(@id)
    parking.update!(left: true, exit_time: DateTime.now)
    parking
  end
end
