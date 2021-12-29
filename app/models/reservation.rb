# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :reception

  validate :validate_create, on: :create

  def validate_create
    unless user.customer?
      errors.add(:user, ': Customer以外予約できません')
    end
    if reception.reserved?
      errors.add(:reservation, ': 予約済みのため予約できません')
    end
  end
end
