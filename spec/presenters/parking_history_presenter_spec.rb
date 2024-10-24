require 'rails_helper'

describe ParkingHistoryPresenter do
  describe '.by_plate' do
    let(:parking_params) { { plate: plate } }
    let(:plate) { 'ABC-1234' }
    let!(:parking1) { Parking.create(plate: plate, entry_time: 1.hour.ago, exit_time: DateTime.now) }
    let!(:parking2) { Parking.create(plate: plate, entry_time: 5.hour.ago, exit_time: DateTime.now) }
    let!(:parking3) { Parking.create(plate: plate, entry_time: 3.hour.ago, exit_time: nil) }

    it 'returns a list of parking history for the given plate' do
      result = ParkingHistoryPresenter.by_plate(parking_params)

      expect(result.size).to eq(3)
      expect(result[0][:id]).to eq(parking1.id)
      expect(result[0][:time]).to eq("60 minutes")

      expect(result[1][:id]).to eq(parking2.id)
      expect(result[1][:time]).to eq("300 minutes")

      expect(result[2][:id]).to eq(parking3.id)
      expect(result[2][:time]).to eq("180 minutes")
    end

    it 'returns an empty list if no parkings are found for the given plate' do
      result = ParkingHistoryPresenter.by_plate({ plate: 'unknown-plate' })

      expect(result).to be_empty
    end
  end
end
