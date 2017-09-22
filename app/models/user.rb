class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :auth_token, uniqueness: true

  def info
    "#{email} - #{created_at} - #{friendly_token}"
  end
end
