# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :reception

  validate :validate_customer_user
  validate :validate_reserved

  def validate_customer_user
    unless user.customer?
      errors.add(:user, ': Customer以外予約できません')
    end
  end

  def validate_reserved
    if reception.reserved?
      errors.add(:reservation, ': 予約済みのため予約できません')
    end
  end
end
