describe 'Employees' do

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

  context 'GET /employees' do
    it 'should return a successful response' do
      get employees_path, headers: headers
      expect(response).to be_successful
    end

    it 'should return a json response' do
      get employees_path, headers: headers
      expect(response.headers['Content-Type']).to eq "application/json; charset=utf-8"
    end

    it 'should return a collection of resources' do
      get employees_path, headers: headers
      expect(JSON.parse response.body).to be_instance_of Array
    end
  end

  context 'GET /employees/:id' do
    it 'should return a successful response' do
      employee = create(:employee)
      get employee_path(employee.id), headers: headers
      expect(response.status).to eq(200)
    end

    it 'should return a json response' do
      employee = create(:employee)
      get employee_path(employee), headers: headers
      expect(response.headers['Content-Type']).to eq "application/json; charset=utf-8"
    end
  end
end