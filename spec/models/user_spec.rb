require 'rails_helper'

RSpec.describe User, type: :model do
  # assim, o user só é criado quando for chamado
  # porém, não posso usar o should no caso de 'be_valid'
  # pois ele tenta usar o subject, que só cahama o método
  # 'new' do model
  # let(:user) { build :user }

  subject { build :user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { should be_valid}

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of :password }
end
