require 'rails_helper'

RSpec.describe User, type: :model do
  # assim o user so e criado quando for chamado,
  # porem, nao posso usar o should no caso de 'be_valid'
  # pois ele tenta usar o subject, que so chama o metodo
  # 'new' do model
  let(:user) { build :user }

  subject { user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { should be_valid }

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of :password }
  it { should validate_uniqueness_of :auth_token }

  describe '#info' do
    it 'returns email and created_at' do
      user.save!

      expect(user.info).to eq("#{user.email} - #{user.created_at}")
    end
  end
end
