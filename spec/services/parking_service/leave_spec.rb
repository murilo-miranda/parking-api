require 'rails_helper'

describe ParkingService::Leave do
  describe '.call' do
    subject { ParkingService::Leave.new(parking_payment_params).call }

    context 'successfully' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now, paid: true) }
      let(:parking_payment_params) { { id: parking.id } }

      it 'update parking exit time' do
        expect { subject }.to change { Parking.last.exit_time }.from(nil).to(within(1.minute).of(DateTime.now))
        expect(Parking.last.left).to eq(true)
      end
    end

    context 'parking not found' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now, paid: true) }
      let(:parking_payment_params) { { id: 999_999 } }

      it 'raise error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'parking not payed' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now) }
      let(:parking_payment_params) { { id: parking.id } }

      it 'raise error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        expect(Parking.last.left).to eq(false)
        expect(Parking.last.exit_time).to be_nil
      end
    end
  end
end
