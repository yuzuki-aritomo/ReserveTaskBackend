class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :reception
<<<<<<< HEAD

  def get_user_name
    user.name
  end
=======
>>>>>>> feature/receptions_get
end
