# generate parking controller with create action
class V1::ParkingController < ApplicationController
  def create
    begin
      plate = parking_params[:plate]
      parking = Parking.new(plate: plate, entry_time: DateTime.now)
      parking.save!
      render json: parking.as_json(only: [ :id, :plate ]), status: :created
    rescue ActiveRecord::RecordInvalid
      render json: parking.errors, status: :unprocessable_entity
    end
  end

  private

  def parking_params
    params.permit(:plate)
  end
end
