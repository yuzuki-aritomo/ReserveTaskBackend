class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :reception

  def get_user_name
    @user = User.find(self.user_id)
    return @user.name
  end

end
