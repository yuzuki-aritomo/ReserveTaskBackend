class ReceptionsRegistrationForm
  include ActiveModel::Model

  attr_accessor :user, :register_dates

  def initialize(user, register_dates)
    @user = user
    @register_dates = register_dates
  end

  def execute
    success_dates = []
    error_dates = []
    @register_dates.each do |register_date|
      reception = @user.reception.build(date: register_date)
      if reception.save
        success_dates.push({
          "reception_id": reception.id,
          "user_name": @user.name,
          "start": reception.date.iso8601,
          "end": (reception.date + 60 * 30).iso8601,
          "reserved": false
        })
      else
        error_dates.push({
          "date": reception.date,
          "error_messages": reception.errors.full_messages
        })
      end
    end
    {
      "data": success_dates,
      "error": error_dates
    }
  end
end
