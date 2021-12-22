# frozen_string_literal: true

class User < ApplicationRecord
  has_many :reception, dependent: :destroy
  has_many :reservation, dependent: :destroy

  enum role: { customer: 1, fp: 2 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :validatable
  include DeviseTokenAuth::Concerns::User
end
