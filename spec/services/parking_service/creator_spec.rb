require 'rails_helper'

describe ParkingService::Creator do
  describe '.call' do
    subject { ParkingService::Creator.new(params).call }

    context 'successfully' do
      let(:params) { { plate: 'ABC-1234' } }

      it 'create a new parking record' do
        expect { subject }.to change { Parking.count }.by(1)

        parking = Parking.last

        expect(parking.plate).to eq(params[:plate])
        expect(parking.entry_time).to be_present
      end
    end

    context 'without plate' do
      let(:params) { { plate: nil } }

      it 'do not create a new parking record' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid plate' do
      let(:params) { { plate: 'Invalid' } }

      it 'do not create a new parking record' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'wrong length plate' do
      let(:params) { { plate: '123' } }

      it 'do not create a new parking record' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
