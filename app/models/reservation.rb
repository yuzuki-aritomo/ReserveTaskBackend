class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :reception

  def get_user_name
    user.name
  end
end
