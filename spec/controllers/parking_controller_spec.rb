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

  describe 'PUT /v1/parking/:id/pay' do
    context 'successfully' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now) }
      let(:expected_response) { { message: "parking payed for ABC-1234" } }

      it 'update payment status' do
        put "/v1/parking/#{parking.id}/pay"

        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response.to_json)
        expect(Parking.last.paid).to eq(true)
      end
    end

    context 'parking not found' do
      it 'show error message' do
        put '/v1/parking/999/pay'

        expect(response.status).to eq(404)
        expect(response.body).to include("Couldn't find Parking with 'id'=999")
      end
    end

    context 'parking already payed' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now, paid: true) }

      it 'show error message' do
        put "/v1/parking/#{parking.id}/pay"

        expect(response.status).to eq(409)
        expect(response.body).to eq("Validation failed: Paid can't be processed again")
      end
    end
  end

  describe 'PUT /v1/parking/:id/out' do
    context 'successfully' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now, paid: true) }
      let(:expected_response) { { message: "ABC-1234 left parking" } }

      it 'update parking exit time' do
        put "/v1/parking/#{parking.id}/out"

        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response.to_json)
        expect(Parking.last.exit_time).to be_present
      end
    end

    context 'parking not found' do
      it 'show error message' do
        put '/v1/parking/999/out'

        expect(response.status).to eq(404)
        expect(response.body).to include("Couldn't find Parking with 'id'=999")
      end
    end

    context 'parking not payed' do
      let!(:parking) { Parking.create(plate: 'ABC-1234', entry_time: DateTime.now) }

      it 'show error message' do
        put "/v1/parking/#{parking.id}/out"

        expect(response.status).to eq(409)
        expect(response.body).to eq("Validation failed: Left unauthorized without paying")
      end
    end
  end
end
