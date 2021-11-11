describe EmployeesController do
  context 'GET /employees' do

    before(:each) { @routes = get :index }

    it 'should return a succesful response' do
      expect(response.status).to eql(200)
    end

    it 'should return a collection of resources' do
      expect(JSON.parse response.body).to be_instance_of Array
    end
  end

  context 'GET /employees/:id' do
    it 'should return a successful response' do
      get :show
      expect(response.status).to eq(200)
    end
  end
end