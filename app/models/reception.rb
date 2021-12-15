# frozen_string_literal: true

class Reception < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :user_id, uniqueness: { scope: [:date] }

  validate :validate_fp_user
  validate :validate_date

  # fp userかチェック
  def validate_fp_user
    unless user.fp?
      errors.add(:user, ': Financial Planner以外登録できません')
    end
  end

  def validate_date
    # 過去の日付は弾く
    if date.present? && date < Date.today
      errors.add(:date, ': 過去の日時は登録できません')
    end
    # 日曜日は弾く
    if date.present? && date.sunday?
      errors.add(:date, ': 日曜日は登録できません')
    end
    # 予約可能時間のチェック
    if date.present?
      if date.saturday? && (date.hour < 11 || 15 <= date.hour)
        errors.add(:date, ': 予約受付時間外は登録できません')
      elsif date.hour < 10 || 18 <= date.hour
        errors.add(:date, ': 予約受付時間外は登録できません')
      end
    end
    # 30分単位のみ受付る
    if date.present? && (date.sec != 0o0 || !(date.min == 0o0 || date.min == 30))
      errors.add(:date, ': 予約開始時間がずれています')
    end
  end
end
