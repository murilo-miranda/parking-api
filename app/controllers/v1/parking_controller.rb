# generate parking controller with create action
class V1::ParkingController < ApplicationController
  def create
    begin
      parking = ParkingService::Creator.new(parking_params).call

      render json: parking_json(parking), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  private

  def parking_params
    params.permit(:plate)
  end

  def parking_json(parking)
    parking.as_json(only: [ :id, :plate ])
  end
end
