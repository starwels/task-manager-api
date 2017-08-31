require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    let!(:user) { create :user }
    let(:user_id) { user.id }
    let(:headers) do
        {
            'Accept': 'application/vnd.taskmanager.v1',
            'Content-Type': Mime[:json].to_s
        }
    end

    before { host! 'api.taskmanager.dev' }

    describe 'GET /users/:id' do
        before do
            get "/users/#{user_id}", params: {}, headers: headers
        end

        context 'when user exists' do
            it 'return status 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns the user' do
                expect(json_body[:id]).to eq(user_id)
            end
        end

        context 'when uses doesn\' exists' do
            let(:user_id) { 1000 }

            it 'returns status 404' do
                expect(response).to have_http_status(404)
            end
        end
    end

    describe 'POST /users' do
        before do
            post '/users', params: { user: user_params }.to_json, headers: headers
        end
        context 'when params are valid' do
            let(:user_params) { attributes_for(:user) }

            it 'returns status 201' do
                expect(response).to have_http_status(201)
            end

            it 'returns json data' do
                expect(json_body[:email]).to eq(user_params[:email])
            end
        end

        context 'when params are invalid' do
            let(:user_params) { attributes_for(:user, email: 'invalid@') }

            it 'returns status 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns json error data' do
                expect(json_body).to have_key(:errors)
            end
        end
    end

    describe 'PUT /users/:id' do
        before do
            put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
        end

        context 'when params are valid' do
            let(:user_params) { {email: 'newemail@emaill.com'} }
            it 'returns status 200' do
                expect(response).to have_http_status(200)
            end

            it 'return json updated user data' do
                expect(json_body[:email]).to eq(user_params[:email])
            end
        end

        context 'when params are invalid' do
            let(:user_params) { attributes_for(:user, email: 'newemail@') }

            it 'returns status 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns json error data' do
                expect(json_body).to have_key(:errors)
            end
        end
    
    end

    describe 'DELETE /users/:id' do
        before do
            delete "/users/#{user_id}", params: {}, headers: headers
        end

        it 'returns status 204' do
            expect(response).to have_http_status(204)
        end

        it 'removes user from db' do
            expect(User.find_by(id: user_id)).to be_nil
        end
    end

end