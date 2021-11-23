 require 'rails_helper'

RSpec.describe "/users", type: :request do
  let(:valid_attributes) {
    {
      "email": Faker::Internet.email,
      "password": "1234"
    }
  }

  let(:invalid_attributes) {
    {
      "email": Faker::Internet.email,
      "password": ""
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      post users_url, params: { user: valid_attributes }
      auth_token = JSON.parse(response.body)['auth_token']
      get users_url, headers: { 'Authorization' => "Bearer: #{auth_token}" }
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "returns the auth token" do
        post users_url, params: { user: valid_attributes }
        expect(JSON.parse(response.body)).to include("auth_token")
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '#login' do

      context 'with valid email and password' do
        before do
          post users_url, params: { user: valid_attributes }
        end

        it 'returns a response with an ok status code' do
          post login_users_path, params: { user: valid_attributes }
          expect(response).to have_http_status :ok
        end

        it 'returns an auth token in the body' do
          post login_users_path, params: { user: valid_attributes }
          expect(JSON.parse response.body).to include 'auth_token'
        end
      end

      context 'with invalid email or password' do
        before do
          post users_url, params: { user: invalid_attributes }
        end

        it 'returns an unauthorized response' do
          post login_users_path, params: { user: valid_attributes }
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end