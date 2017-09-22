require 'rails_helper'

RSpec.describe User, type: :model do
  # let so cria o obj quando e chamado
  # let! cria antes
  
  let(:user) { build :user }

  it { expect(user).to respond_to :email }
  it { expect(user).to respond_to :password }
  it { expect(user).to respond_to :password_confirmation }

  it { expect(user).to be_valid }

  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(user).to validate_confirmation_of :password }
  it { expect(user).to validate_uniqueness_of :auth_token }

  describe '#info' do
    it 'returns email and created_at' do
      user.save!

      expect(user.info).to eq("#{user.email} - #{user.created_at}")
    end
  end
end
