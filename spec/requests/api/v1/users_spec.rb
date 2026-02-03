require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:valid_attributes) { { user: { name: 'Andre', email: 'andre@teste.com' } } }
  let(:invalid_attributes) { { user: { name: '', email: 'invalido' } } }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'GET /api/v1/users' do
    it 'returns all users' do
      User.create(name: 'User 1', email: 'user1@teste.com')
      User.create(name: 'User 2', email: 'user2@teste.com')

      get '/api/v1/users'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns empty array when no users' do
      get '/api/v1/users'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'when user exists' do
      it 'returns the user' do
        user = User.create(name: 'Andre', email: 'andre@teste.com')

        get "/api/v1/users/#{user.id}"

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Andre')
        expect(json['email']).to eq('andre@teste.com')
      end
    end

    context 'when user does not exist' do
      it 'returns not found' do
        get '/api/v1/users/99999'

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end
    end
  end

  describe 'POST /api/v1/users' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post '/api/v1/users', params: valid_attributes.to_json, headers: headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Andre')
      end
    end

    context 'with invalid attributes' do
      it 'does not create user and returns errors' do
        expect {
          post '/api/v1/users', params: invalid_attributes.to_json, headers: headers
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end

    context 'with duplicate email' do
      it 'returns error' do
        User.create(name: 'Existente', email: 'andre@teste.com')

        post '/api/v1/users', params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Email has already been taken')
      end
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    let!(:user) { User.create(name: 'Andre', email: 'andre@teste.com') }

    context 'with valid attributes' do
      it 'updates the user' do
        patch "/api/v1/users/#{user.id}", 
              params: { user: { name: 'Andre Silva' } }.to_json, 
              headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq('Andre Silva')
      end
    end

    context 'with invalid attributes' do
      it 'returns errors' do
        patch "/api/v1/users/#{user.id}", 
              params: { user: { name: '' } }.to_json, 
              headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    context 'when user has no transactions' do
      it 'deletes the user' do
        user = User.create(name: 'Andre', email: 'andre@teste.com')

        expect {
          delete "/api/v1/users/#{user.id}"
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user does not exist' do
      it 'returns not found' do
        delete '/api/v1/users/99999'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
