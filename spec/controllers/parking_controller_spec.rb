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
        expect(Parking.last.left).to eq(true)
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

  describe 'GET /v1/parking/:plate' do
    context 'with valid plate' do
      let(:plate) { 'ABC-1234' }
      let!(:parking1) { Parking.create(plate: plate, entry_time: 1.hour.ago, exit_time: DateTime.now) }
      let!(:parking2) { Parking.create(plate: plate, entry_time: 5.hour.ago, exit_time: DateTime.now) }
      let!(:parking3) { Parking.create(plate: plate, entry_time: 3.hour.ago, exit_time: nil) }
      let(:expected_response) {
        [
          { id: parking1.id, time: "60 minutes", paid: parking1.paid, left: parking1.left },
          { id: parking2.id, time: "300 minutes", paid: parking2.paid, left: parking2.left },
          { id: parking3.id, time: "180 minutes", paid: parking3.paid, left: parking3.left }
        ]
      }

      it 'returns a list of parking history for the given plate' do
        get "/v1/parking/#{plate}"

        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response.to_json)
      end

      context 'have other plate record' do
        let(:other_plate) { 'DEF-1234' }
        let!(:parking4) { Parking.create(plate: other_plate, entry_time: 3.hour.ago) }

        it 'the return list should have only the given plate' do
          get "/v1/parking/#{plate}"

          expect(response.status).to eq(200)
          expect(response.body).to eq(expected_response.to_json)
        end
      end
    end

    context 'with invalid plate' do
      it 'show error message' do
        get '/v1/parking/Invalid'

        expect(response.status).to eq(404)
        expect(response.body).to include("Couldnt find Parking history for plate: Invalid")
      end
    end
  end
end
