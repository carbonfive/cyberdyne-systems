module TwilioService
  include Rails.application.routes.url_helpers
  extend self

  def make(call)
    create_call(
      from: main_number,
      to: call.user.phone_number,
      url: user_call_twilio_call_url(call, host: host)
    )
  end

  def make_queue_pickup_call_to(number)
    create_call(
      from: main_number,
      to: number,
      url: pickup_from_queue_twilio_calls_url(host: host)
    )
  end

  def hang_up(call_sid)
    call(call_sid).hangup
  end

  private

  def main_number
    ENV['CYBERDYNE_PHONE_NUMBER']
  end

  def host
    ENV['CYBERDYNE_HOST']
  end

  def client
    @client ||= Twilio::REST::Client.new(ENV['CYBERDYNE_TWILIO_ACCOUNT_SID'], ENV['CYBERDYNE_TWILIO_AUTH_TOKEN'])
  end

  def create_call(options)
    calls.create(options)
  end

  def calls
    client.account.calls
  end

  def call(call_sid)
    calls.get(call_sid)
  end
end
