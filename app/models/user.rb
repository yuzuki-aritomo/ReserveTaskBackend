# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :validatable
  include DeviseTokenAuth::Concerns::User

  def is_FP
    if self.role == 2
      return true
    else
      return false
    end
  end

  def is_User
    if self.role == 1
      return true
    else
      return false
    end
  end

end
