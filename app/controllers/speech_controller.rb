class SpeechController < ApplicationController
  require 'rest-client'
  require 'json'

  def text_to_speech
    subscription_key = 'your_subscription_key'
    endpoint = 'your_endpoint'
    text = 'Hello, this is a test.'

    speech_api_url = "#{endpoint}/cognitiveservices/v1"

    response = RestClient.post(
      "#{speech_api_url}/synthesize",
      { text: text }.to_json,
      content_type: :json,
      accept: :audio/wav,
      'Ocp-Apim-Subscription-Key': subscription_key
    )

    # Do something with the audio data (e.g., save to a file, stream to the client)
    audio_data = response.body

    # Your implementation here
  end

  def speech_to_text
    subscription_key = 'your_subscription_key'
    endpoint = 'your_endpoint'
    audio_file_path = 'path/to/audio/file.wav'

    speech_api_url = "#{endpoint}/cognitiveservices/v1"

    audio_data = File.binread(audio_file_path)

    response = RestClient.post(
      "#{speech_api_url}/recognize",
      audio_data,
      content_type: 'audio/wav',
      accept: :json,
      'Ocp-Apim-Subscription-Key': subscription_key
    )

    result = JSON.parse(response.body)

    if result['RecognitionStatus'] == 'Success'
      # Handle recognized text
      recognized_text = result['DisplayText']
      # Your implementation here
    else
      # Handle the error
      puts "Error recognizing speech: #{result['RecognitionStatus']} - #{result['ErrorDetails']}"
    end
  end
end
