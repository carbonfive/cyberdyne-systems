xml.instruct!
xml.Response do
  xml.Dial(action: goodbye_twilio_call_path(@call)) do
    xml.Number(url: phone_number_call_twilio_call_path(@call)) do
      xml.text! @call.phone_number
    end
  end
end

