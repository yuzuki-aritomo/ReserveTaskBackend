# frozen_string_literal: true

class Reception < ApplicationRecord
  has_many :reservation, dependent: :destroy
  belongs_to :user

  validates :user_id, presence: true
  validates :received_at, presence: true
  validates :user_id, uniqueness: { scope: [:received_at] }

  validate :validate_fp_user
  validate :validate_received_at

  # fp userかチェック
  def validate_fp_user
    unless user.fp?
      errors.add(:user, ': Financial Planner以外登録できません')
    end
  end

  def validate_received_at
    if received_at.blank?
      errors.add(:date, ': 日時が登録されていません')
    end
    # 過去の日付は弾く
    if received_at < Date.today
      errors.add(:date, ': 過去の日時は登録できません')
    end
    # 日曜日は弾く
    if received_at.sunday?
      errors.add(:date, ': 日曜日は登録できません')
    end
    # 予約可能時間のチェック
    if received_at.present?
      if received_at.saturday? && (received_at.hour < 11 || received_at.hour >= 15)
        errors.add(:date, ': 予約受付時間外は登録できません')
      elsif received_at.hour < 10 || received_at.hour >= 18
        errors.add(:date, ': 予約受付時間外は登録できません')
      end
    end
    # 30分単位のみ受付る
    if received_at.sec != 0 || !(received_at.min.zero? || received_at.min == 30)
      errors.add(:date, ': 予約開始時間がずれています')
    end
  end
end
