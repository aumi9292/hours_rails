describe 'Employees' do

  context 'GET /employees' do
    it 'should return a successful response' do
      get employees_path
      expect(response).to be_successful
    end

    it 'should return a json response' do
      get employees_path
      expect(response.headers['Content-Type']).to eq "application/json; charset=utf-8"
    end

    it 'should return a collection of resources' do
      get employees_path
      expect(JSON.parse response.body).to be_instance_of Array
    end
  end

  context 'GET /employees/:id' do
    it 'should return a successful response' do
      employee = create(:employee)
      get employee_path(employee)
      expect(response.status).to eq(200)
    end

    it 'should return a json response' do
      employee = create(:employee)
      get employee_path(employee)
      expect(response.headers['Content-Type']).to eq "application/json; charset=utf-8"
    end
  end
end