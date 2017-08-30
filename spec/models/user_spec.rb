require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build :user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { expect(@user).to be_valid}

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
end
