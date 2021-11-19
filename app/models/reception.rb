class Reception < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :date, presence: true
  validates :user_id, uniqueness: { scope: [ :date ] }

  validate :user_check_role
  validate :date_check_in_the_past
  validate :date_check_in_sunday
  validate :date_check_in_reception_hour
  validate :date_check_in_reception_min_sec

  #fp userかチェック
  def user_check_role
    @user = User.find(user_id)
    if !@user.is_FP
      errors.add(:user, ": Financial Planner以外登録できません")
    end
  end
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
  def date_check_in_reception_hour
    if date.present?
      if date.saturday? && (date.hour < 11 || 15 <= date.hour )
        errors.add(:date, ": 予約受付時間外は登録できません")
      elsif (date.hour < 10 || 18 <= date.hour )
        errors.add(:date, ": 予約受付時間外は登録できません")
      end
    end
  end
  #30分単位のみ受付る
  def date_check_in_reception_min_sec
    if date.present?
      if date.sec != 00 || !(date.min == 00 || date.min == 30)
        errors.add(:date, ": 予約開始時間がずれています")
      end
    end
  end
end
