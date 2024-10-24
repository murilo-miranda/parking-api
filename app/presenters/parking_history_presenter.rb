class ParkingHistoryPresenter
  def self.by_plate(parking_params)
    plate = parking_params[:plate]
    Parking.where(plate: plate).map do |parking|
      {
        id: parking.id,
        time: time_diff(parking.entry_time, parking.exit_time),
        paid: parking.paid,
        left: parking.left
      }
    end
  end

  private

  def self.time_diff(entry_time, exit_time)
    exit_time ||= DateTime.now

    total_minutes = ((exit_time.to_time - entry_time.to_time) / 60).to_i

    "#{total_minutes} minutes"
  end
end
