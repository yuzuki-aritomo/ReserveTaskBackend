# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :reception, dependent: :destroy
  has_many :reservation, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :validatable
  include DeviseTokenAuth::Concerns::User

  def fp?
    role == 2
  end

  def user?
    role == 1
  end
end
