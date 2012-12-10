xml.instruct!
xml.Response do
  xml.Say 'Hello. Are you'
  xml.Play 'https://s3.amazonaws.com/Carbonfive/placeholder.wav'
  xml.Say 'If not, please hold.'
  xml.Play 'https://s3.amazonaws.com/Carbonfive/sign_off.wav'
  xml.Enqueue(action: goodbye_twilio_call_path(@call), waitUrl: hold_twilio_call_path(@call)) do
    xml.text! 'hold'
  end
end
