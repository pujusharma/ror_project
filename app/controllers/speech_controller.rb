class SpeechController < ApplicationController
  require 'rest-client'
  require 'json'

  skip_before_action :verify_authenticity_token, only: [:text_to_speech, :speech_to_text]

  def text_to_speech_form

  end

  def text_to_speech
    subscription_key = ENV["AZURE_SUBSCRIPTION_KEY"]
    region = ENV["REGION"] 
    endpoint = "https://#{region}.tts.speech.microsoft.com/"

    text = params[:text].to_s
    speech_api_url = "#{endpoint}cognitiveservices/v1"

    headers = {
      'Content-Type' => 'application/ssml+xml',
      'X-Microsoft-OutputFormat' => 'audio-16khz-32kbitrate-mono-mp3',
      'Authorization' => "Bearer #{get_access_token(subscription_key, region)}"
    }

    request_body = "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>
                    <voice name='en-US-AriaNeural'>#{text}</voice></speak>"

    begin
      response = RestClient.post(
        speech_api_url,
        request_body,
        headers
      )

      # Do something with the audio data (e.g., save to a file, stream to the client)
      File.open('output.mp3', 'wb') do |file|
        file.write(response.body)
      end
      @audio_file_url = '/output.mp3'
      puts 'Speech saved to output.mp3'
      
      # Your implementation here
      # respond_to(&:js)
      respond_to do |format|
        format.html 
        format.turbo_stream { render turbo_stream: turbo_stream.update('audio_file', partial: 'display_speech') }
      end
    rescue RestClient::ExceptionWithResponse => e
      render json: { error: "Speech synthesis failed: #{e.message}" }, status: e.http_code
    end
  end

  def output_audio
    audio_file_path = Rails.root.join('output.mp3')
    send_file audio_file_path, type: 'audio/mp3', disposition: 'inline'
  end

  private

  def get_access_token(subscription_key, region)
    token_url = "https://#{region}.api.cognitive.microsoft.com/sts/v1.0/issueToken"
    headers = {
      'Ocp-Apim-Subscription-Key' => subscription_key,
    }

    begin
      response = RestClient.post(
        token_url,
        nil,
        headers
      )

      response.body

    rescue RestClient::ExceptionWithResponse => e
      raise "Error obtaining access token: #{e.message}"
    end
  end
end