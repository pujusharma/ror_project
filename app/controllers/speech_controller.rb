class SpeechController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:text_to_speech]
  require 'rest-client'
  require 'json'

  def text_to_speech
    subscription_key = ENV["AZURE_SUBSCRIPTION_KEY"]
    endpoint = ENV["AZURE_ENDPOINT"]
    region = ENV["AZURE_REGION"]
    endpoint_url = "https://#{ENV["AZURE_REGION"]}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1"
   
 
    response = RestClient.post(
      endpoint_url,
      Content-Type: 'application/json',
      Accept: 'audio/wav',
      'Ocp-Apim-Subscription-Key': subscription_key,
      language: 'en-US',
      format: 'detailed'
    )


    # Do something with the audio data (e.g., save to a file, stream to the client)
    audio_data = response.body
   
    # Your implementation here
  end

  def speech_to_text
    subscription_key = ENV["AZURE_SUBSCRIPTION_KEY"]
    endpoint = ENV["AZURE_ENDPOINT"]
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
