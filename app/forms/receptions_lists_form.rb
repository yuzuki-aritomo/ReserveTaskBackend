class ReceptionsListsForm
  include ActiveModel::Model

  def initialize(user, params)
    @user = user
    @params = params
  end

  def execute
    start_date = convert_to_date(@params[:start]) || Time.zone.now.prev_month
    end_date = convert_to_date(@params[:end]) || Time.zone.now.next_month
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
    rescue StandardError
      nil
    end
end
