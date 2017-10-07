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

  describe '#authenticate_with_token!' do
    # modifying subject controller
    controller do
      before_action :authenticate_with_token!

      def restricted_action; end
    end

    context 'when no user is logged in' do
      before do
        # setting an action just for test purpose
        allow(app_controller).to receive(:current_user).and_return(nil)
        routes.draw { get 'restricted_action' => 'anonymous#restricted_action'}
        get :restricted_action
      end

      it 'returns code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error json data' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe '#user_logged_in?' do
    context 'when there is a user logged in' do
      before do
        user = create(:user)
        allow(app_controller).to receive(:current_user).and_return(user)
      end

      it { expect(app_controller.user_logged_in?).to be true }
    end

    context 'when there is no user logged in' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
      end

      it { expect(app_controller.user_logged_in?).to be false }
    end
  end
end