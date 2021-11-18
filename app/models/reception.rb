class Reception < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :date, presence: true

  # validate :date_check_in_the_past
  # validate :date_check_in_sunday
  # validate :date_check_in_reception_time
  # validate :date_check_in_reception_hour

  #過去の日付は弾く
  def date_check_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, ": 過去の日付は登録できません")
    end
  end
  #日曜日は弾く
  def date_check_in_sunday
    if date.present? && date.sunday?
      errors.add(:date, ": 日曜日は登録できません")
    end
  end
  #予約可能時間のチェック
  def date_check_in_reception_time
    if date.present?
      if date.saturday? && (date.min < 11 || 15 <= date.min )
        errors.add(:date, ": 予約受付時間外は登録できません")
      elsif (date.min < 10 || 18 <= date.min )
        errors.add(:date, ": 予約受付時間外は登録できません")
      end
    end
  end
  #30分単位のみ受付る
  def date_check_in_reception_hour
    if date.present? && (date.min != 00 || date.min != 30 || date.sec != 00)
      errors.add(:date, ": 予約開始時間がずれています")
    end
  end
end
