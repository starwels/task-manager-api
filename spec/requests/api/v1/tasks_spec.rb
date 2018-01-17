require 'rails_helper'

RSpec.describe 'Tasks API' do
  before { host! 'api.taskmanager.dev' }

  let!(:user) { create :user }
  let(:headers) do
      {
          'Accept': 'application/vnd.taskmanager.v1',
          'Content-Type': Mime[:json].to_s,
          'Authorization': user.auth_token
      }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}, headers: headers
    end

    it 'returns conde 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tasks' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    before { get "/tasks/#{task.id}", params: {}, headers: headers }

    it 'returns code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns task json' do
      expect(json_body[:title]).to eq(task.title)
    end
  end

  describe 'POST /task' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:task_params) { attributes_for(:task) }

      it 'returns code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves task in db' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end

      it 'returns task json data' do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'assigns created task to current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when params are invalid' do
      let(:task_params) { attributes_for(:task, title: '') }
      
      it 'returns code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not saves task in db' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end

      it 'returns task json error for title' do
        expect(json_body[:errors]).to have_key(:title) 
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id)}
    before do
      put "/tasks/#{task.id}", params: task_params.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:task_params) { { title: 'New task title' } }

      it 'returns code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns updated task json' do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'updates task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
    end

    context 'when params are invalid' do
      let(:task_params) { {title: ' '} }

      it 'returns code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json error for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'does not update task in database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    before do
      delete "/tasks/#{task.id}", params: {}, headers: headers
    end

    it 'returns code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes task from database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end