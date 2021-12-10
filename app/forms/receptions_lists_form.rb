class ReceptionsListsForm
  include ActiveModel::Model

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def execute
    # start_date = convert_to_date(params[:start]) || Time.now.prev_month
    # end_date = convert_to_date(params[:end]) || Time.now.next_month
    start_date = Time.zone.now.prev_month
    end_date = Time.zone.now.next_month

    @receptions = @user.reception.where(date: start_date...end_date)
    reception_dates = []
    @receptions.map do |reception|
      @reservation = reception.reservation.find_by(cancel_flag: false)
      reserved = @reservation ? true : false
      user_name = @reservation ? @reservation.get_user_name : ''
      reception_dates.push({
        "reception_id": reception.id,
        "user_name": user_name,
        "start": reception.date.iso8601,
        "end": (reception.date + 60 * 30).iso8601,
        "reserved": reserved
      })
    end
    {
      data: reception_dates
    }
  end

  private

  def convert_to_date(date)
    Time.zone.parse(date)
  rescue
    nil
  end
end
