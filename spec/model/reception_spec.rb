require 'rails_helper'

RSpec.describe Reception, type: :model do
  before do
    @customer = User.create(
      id: 1,
      role: 1, # customer
      name: 'customer',
      email: 'test@test.com',
      password: 'password'
    )
    @fp = User.create(
      id: 2,
      role: 2, # fp
      name: 'fp',
      email: 'test1@test.com',
      password: 'password'
    )
  end

  it '日時を登録すると登録出来ていること' do
    reception = @fp.reception.new(received_at: '2022-12-12T03:00:00.000Z')
    expect(reception.received_at).to eq '2022-12-12T03:00:00.000Z'
  end

  it 'fpのみ登録できる' do
    reception = @fp.reception.new(received_at: '2022-12-12T03:00:00.000Z')
    expect(reception.received_at).to eq '2022-12-12T03:00:00.000Z'
    reception = @customer.reception.new(received_at: '2022-12-13T04:00:00.000Z')
    expect(reception.valid?).to eq(false)
  end

  it '過去の日付は登録できない' do
    reception = @fp.reception.new(received_at: '2000-01-03T04:00:00.000Z') # 月曜日 13:00~
    expect(reception.valid?).to eq(false)
  end

  it '日曜日は登録出来ない' do
    reception = @fp.reception.new(received_at: '2022-12-04T03:00:00.000Z') # 日曜日 12:00~
    expect(reception.valid?).to eq(false)
  end

  it '土曜日の予約可能時間が11~15時の間のみ登録可能である' do
    reception = @fp.reception.new(received_at: '2022-12-03T02:00:00.000Z') # 土曜日 11:00~ OK
    expect(reception).to be_valid
    reception = @fp.reception.new(received_at: '2022-12-03T05:30:00.000Z') # 土曜日 14:30~ OK
    expect(reception).to be_valid
    reception = @fp.reception.new(received_at: '2022-12-03T01:30:00.000Z') # 土曜日 10:30~ NG
    expect(reception.valid?).to eq(false)
    reception = @fp.reception.new(received_at: '2022-12-03T06:00:00.000Z') # 土曜日 15:00~ NG
    expect(reception.valid?).to eq(false)
  end

  it '平日の予約可能時間が10~18時の間のみ登録可能である' do
    reception = @fp.reception.new(received_at: '2022-12-05T01:00:00.000Z') # 月曜日 10:00~ OK
    expect(reception).to be_valid
    reception = @fp.reception.new(received_at: '2022-12-05T08:30:00.000Z') # 月曜日 17:30~ OK
    expect(reception).to be_valid
    reception = @fp.reception.new(received_at: '2022-12-05T00:30:00.000Z') # 月曜日 09:30~ NG
    expect(reception.valid?).to eq(false)
    reception = @fp.reception.new(received_at: '2022-12-05T09:00:00.000Z') # 月曜日 18:00~ NG
    expect(reception.valid?).to eq(false)
  end

  it '予約登録時間が30分単位である' do
    reception = @fp.reception.new(received_at: '2022-12-05T03:10:00.000Z') # 月曜日 12:10~ NG
    expect(reception.valid?).to eq(false)
    reception = @fp.reception.new(received_at: '2022-12-05T03:00:34.000Z') # 月曜日 12:00 34s ~ NG
    expect(reception.valid?).to eq(false)
  end

  it '同じFPが同じ時間を登録出来ない' do
    reception = @fp.reception.create(received_at: '2022-12-05T03:00:00.000Z') # 月曜日 12:00~ OK
    expect(reception).to be_valid
    reception = @fp.reception.new(received_at: '2022-12-05T03:00:00.000Z') # 月曜日 12:00~ NG
    expect(reception.valid?).to eq(false)
  end

end
