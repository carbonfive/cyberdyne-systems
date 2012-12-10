xml.instruct!
xml.Response do
  xml.Dial(url: goodbye_twilio_call_path(@call)) do
    xml.Number(url: user_call_twilio_call_path(@call)) do
      xml.text! @call.user.phone_number
    end
  end
end
