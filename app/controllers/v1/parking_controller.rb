class V1::ParkingController < ApplicationController
  def create
    begin
      parking = ParkingService::Creator.new(parking_params).call

      render json: parking_json(parking), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  def pay
    parking = ParkingService::Payer.new(parking_payment_params).call

    render json: { message: "parking payed for #{parking.plate}" }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: e.message, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: e.message, status: :conflict
  end

  private

  def parking_params
    params.permit(:plate)
  end

  def parking_payment_params
    params.permit(:id)
  end

  def parking_json(parking)
    parking.as_json(only: [ :id, :plate ])
  end
end
