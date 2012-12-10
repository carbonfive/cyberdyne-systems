xml.instruct!
xml.Response do
  xml.Dial do
    xml.Queue(url: dequeued_twilio_calls_path, method: 'POST') do
      xml.text! 'hold'
    end
  end
end
