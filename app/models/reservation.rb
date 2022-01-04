# frozen_string_literal: true

class Reservation < ApplicationRecord
  attr_accessor :current_user

  belongs_to :user
  belongs_to :reception

  validate :validate_create, on: :create
  validate :validate_update, on: :update

  def validate_create
    unless user.customer?
      errors.add(:user, ': Customer以外予約できません')
    end
    if reception.reserved?
      errors.add(:reservation, ': 予約済みのため予約できません')
    end
  end

  def validate_update
    if (reception.user.id != current_user.id) && (user.id != current_user.id)
      errors.add(:reservation, ': キャンセル権限がありません')
    end
  end
end
