require 'rails_helper'

describe ParkingService::Payer do
  describe '.call' do
    subject { ParkingService::Payer.new(params).call }

    context 'successfully' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now) }
      let(:params) { { id: parking.id } }

      it 'update payment status' do
        expect { subject }.to change { Parking.last.paid }.from(false).to(true)
      end
    end

    context 'parking not found' do
      let(:params) { { id: 999_999 } }

      it 'show error message' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'already paid' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now, paid: true) }
      let(:params) { { id: parking.id } }

      it 'show error message' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
