require 'rails_helper'

RSpec.describe Authenticable do
  # Simulating a controller (anonymous controller of rspec)
  # it inherits of original ApplicationController
  controller(ApplicationController) do
    include Authenticable
  end

  let(:app_controller) { subject }

  describe '#current_user' do
    let(:user) { create(:user) }

    before do
      # mock to define a method
      req = double(headers: { Authorization: user.auth_token })
      # when require request method return req mock
      allow(app_controller).to receive(:request).and_return(req)
    end

    it 'returns the user from authorization header' do
      expect(app_controller.current_user).to eq(user)
    end
  end
end