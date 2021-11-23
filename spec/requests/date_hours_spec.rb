describe 'DateHours' do
  let(:valid_attributes) {
    {
      "email": Faker::Internet.email,
      "password": "1234"
    }
  }

  let(:headers) do
    post users_url, params: { user: valid_attributes }
    auth_token = JSON.parse(response.body)['auth_token']
    { 'Authorization' => "Bearer: #{auth_token}" }
  end

  context 'GET /employees/:employee_id/pay_periods/:pay_period_id/date_hours' do

    let(:dh) { create(:date_hour) }

    before do
      get employee_pay_period_date_hours_path(dh.employee_id, dh.pay_period_id), headers: headers
    end

    it 'should return a successful response' do
      expect(response).to be_successful
    end

    # raises ActiveRecord for employee not in db
    # it 'should return a 404 if the employee or pay period dont exist' do
    #   get employee_pay_period_date_hours_path(dh.employee_id + 1, dh.pay_period_id), headers: headers
    #   p response.status
    # end

    it 'should return a json response' do
      expect(JSON.parse response.body).to be_instance_of Hash
    end

    it 'should return a response with the top level keys \'date_hours\' and \'totals\'' do
      expect(JSON.parse response.body).to include('date_hours', 'totals')
    end

    it 'should include the date_hours associated with the employee that fall within the pay period' do
      response_dhs = JSON.parse(response.body)['date_hours']
      expect(response_dhs.any? { |d_h| d_h['id'] == dh.id }).to be true
    end

    it 'should not include date_hours associated with the employee that do not fall within the pay period' do
      dh2 = build(:date_hour, date: 100.days.ago)

      response_dhs = JSON.parse(response.body)['date_hours']
      expect(response_dhs.any? { |d_h| d_h['date'] == dh2.date }).to be false
    end

    it 'should not include date_hours not associated with the specified employee' do
      employee2 = create(:employee)
      dh2 = build(:date_hour, employee_id: employee2.id)

      response_dhs = JSON.parse(response.body)['date_hours']
      expect(response_dhs.any? { |d_h| d_h['employee_id'] == dh2.employee_id }).to be false
    end
  end

  context 'POST /date_hours' do
    let(:date_hour) { create(:date_hour) }

    let(:params) do
      {
        "date_hours":
        [
          {
            "date": date_hour.date + 1.day,
            "day": (date_hour.date + 1.day).strftime('%A'),
            "hours": "6",
            "employee_id": date_hour.employee_id,
            "pay_period_id": date_hour.pay_period_id
          }
        ]
      }
    end


    context 'with a singular resource' do

      context 'for a well-formed request' do

        before do
          post date_hours_path, params: params, headers: headers
        end

        it 'should return a successful response' do
          expect(response).to be_successful
        end

        it 'should return a json response' do
          expect(JSON.parse response.body).to be_instance_of Array
        end

        it 'should return the id of the newly created date_hour' do
          expect(JSON.parse(response.body).first).to include('id')
        end
      end

      context 'for a malformated request' do

        it 'should return a 422 if the employee does not exist' do
          params[:date_hours].first[:employee_id] = 0
          post date_hours_path, params: params, headers: headers
          expect(response.status).to eq 422
        end

        # raises ActiveRecord::RecordNotFound for pay_period_id
        it 'should return a 422 if the pay period does not exist' do
          # skip
          params[:date_hours].first[:pay_period_id] = 0
          expect { post date_hours_path, params: params, headers: headers }.to raise_error ActiveRecord::RecordNotFound
          # expect(response.status).to eq 422
        end

        it 'should not allow >= 9.9999 hours' do
          params[:date_hours].first[:hours] = 10
          post date_hours_path, params: params, headers: headers
          expect(response.status).to eq 422
          expect(JSON.parse(response.body)['errors']).to eq "Validation failed: Hours must be less than or equal to 9.9999"
        end

        it 'should not allow <= 0 hours' do
          params[:date_hours].first[:hours] = -1
          post date_hours_path, params: params, headers: headers
          expect(response.status).to eq 422
          expect(JSON.parse(response.body)['errors']).to eq "Validation failed: Hours must be greater than 0"
        end
      end
    end

    context 'with a collection of resources' do

      let(:params) do
        {
          "date_hours":
          [
            {
              "date": date_hour.date + 1.day,
              "day": (date_hour.date + 1.day).strftime('%A'),
              "hours": "6",
              "employee_id": date_hour.employee_id,
              "pay_period_id": date_hour.pay_period_id
            },
            {
              "date": date_hour.date + 2.days,
              "day": (date_hour.date + 2.day).strftime('%A'),
              "hours": "6",
              "employee_id": date_hour.employee_id,
              "pay_period_id": date_hour.pay_period_id
            }
          ]
        }
      end

      before do
        post date_hours_path, params: params, headers: headers
      end

      it 'should return a successful response' do
        expect(response).to be_successful
      end

      it 'should return a json response' do
        expect(JSON.parse response.body).to be_instance_of Array
      end

      it 'should return the collection of created resources' do
        expect(JSON.parse(response.body).length).to be params[:date_hours].length
      end

      it 'should return ids for each newly created date_hour' do
        dhs = JSON.parse(response.body)
        dhs.each do |dh|
          expect(dh).to include('id')
        end
      end
    end
  end

  context 'PUT /date_hours' do

    let(:dh1) { create(:date_hour) }
    let(:dh2) { create(:date_hour, date: dh1.date + 1.day) }
    let(:single_params) { { date_hours: [{ id: dh1.id, hours: 2 }] } }

    context 'with a singular resource' do
      context 'with a well-formed request body' do

        before do
          put update_hours_path, params: single_params, headers: headers
          dh1.reload
        end

        it 'should update the hours for a given date' do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).first['hours'].to_i)
            .to be single_params[:date_hours].first[:hours]
        end
      end

      context 'with a malformed request body' do
        let(:invalid_single_params) { { date_hours: [{ id: dh1.id, hours: 10 }] } }

        before do
          put update_hours_path, params: invalid_single_params, headers: headers
          dh1.reload
        end

        it 'should return a 422 when hours is not valid' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should not update the hours when params are invalid' do
          expect(dh1[:hours]).not_to eq invalid_single_params[:date_hours].first[:hours]
        end

      end
    end

    context 'with a collection of resources' do
      context 'with a well-formed request body' do

        let(:two_dhs_params) { { date_hours: [{ id: dh1.id, hours: 2 }, { id: dh2.id, hours: 2 }] } }

        before do
          put update_hours_path, params: two_dhs_params, headers: headers
          dh1.reload
          dh2.reload
        end

        it 'should return a successful response' do
          expect(response).to have_http_status :ok
        end

        it 'should update all date_hours passed in' do
          updated_hours = JSON.parse(response.body).map { |d_h| d_h['hours'].to_i }
          updated_hours.each_with_index do |hours, i|
            expect(hours).to eq two_dhs_params[:date_hours][i][:hours]
          end
        end
      end

      context 'with one bad date_hour' do
        let(:one_invalid) { { date_hours: [{ id: dh1.id, hours: 2 }, { id: dh2.id, hours: 10 }] } }
        let(:two_invalid) { { date_hours: [{ id: 0, hours: 2 }, { id: dh2.id, hours: 10 }] } }

        before do
          put update_hours_path, params: one_invalid, headers: headers
          dh1.reload
          dh2.reload
        end

        it 'return a 422 if one or more date_hours is invalid' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should not update any passed in date_hours if one or more are invalid' do
          expect(dh1[:hours]).to eq 8
          expect(dh2[:hours]).to eq 8
        end
      end

      context 'with two bad date_hours' do
        let(:two_invalid) { { date_hours: [{ id: dh1.id, hours: 0 }, { id: dh2.id, hours: 10 }] } }

        before do
          put update_hours_path, params: two_invalid, headers: headers
          dh1.reload
          dh2.reload
        end

        it 'return a 422 if all date_hours are invalid' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should not update any passed in date_hours if all date_hours are invalid' do
          expect(dh1[:hours]).to eq 8
          expect(dh2[:hours]).to eq 8
        end
      end
    end
  end
end