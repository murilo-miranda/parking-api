require 'rails_helper'

describe V1::ParkingController, type: :request do
  describe 'POST /v1/parking' do
    context 'successfully' do
      let(:expected_response) { { id: Parking.last.id, plate: 'ABC-1234' } }

      it 'create a new parking record' do
        post '/v1/parking', params: { plate: 'ABC-1234' }

        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response.to_json)
        expect(Parking.count).to eq(1)
      end
    end

    context 'without plate' do
      it 'do not create a new parking record' do
        post '/v1/parking'

        expect(response.status).to eq(422)
        expect(response.body).to include("can't be blank")
        expect(Parking.count).to eq(0)
      end
    end

    context 'with invalid plate' do
      it 'do not create a new parking record' do
        post '/v1/parking', params: { plate: 'Invalid' }

        expect(response.status).to eq(422)
        expect(response.body).to include("is invalid")
        expect(Parking.count).to eq(0)
      end
    end

    context 'wrong length plate' do
      it 'do not create a new parking record' do
        post '/v1/parking', params: { plate: 'ABC-12345' }

        expect(response.status).to eq(422)
        expect(response.body).to include("is the wrong length")
        expect(Parking.count).to eq(0)
      end
    end
  end
end
