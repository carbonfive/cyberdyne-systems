require 'wopr/cucumber'

require File.join(File.dirname(__FILE__), '..', '..', 'staging')

Wopr.configure do |config|
  config.twilio_server_port = 4000
  config.twilio_callback_host = 'http://rudyjahchan.fwd.wf'
  config.twilio_account_sid = TWILIO_ACCOUNT_SID
  config.twilio_auth_token = TWILIO_AUTH_TOKEN
end

require File.join(File.dirname(__FILE__), '..', '..', 'bots')

Wopr::TwilioService.new.update_callbacks([Wopr::Bot[:ahnold].phone_number, Wopr::Bot[:kyle].phone_number])

Wopr::TwilioCallbackServer.boot
