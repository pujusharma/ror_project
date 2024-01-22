class SpeechController < ApplicationController
  require 'rest-client'
  require 'json'

  skip_before_action :verify_authenticity_token, only: [:text_to_speech, :speech_to_text]

  def text_to_speech_form

  end
  def speech_to_text_form

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

  def speech_to_text
    audio_file = params[:audio_file]
  
    if audio_file
      # Replace with your Azure Speech subscription key and region
      speech_key = ENV["AZURE_SUBSCRIPTION_KEY"]
      speech_region = ENV["REGION"] 
  
      # API endpoint
      api_endpoint = "https://#{speech_region}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=detailed"
  
      # Headers
      headers = {
        'Ocp-Apim-Subscription-Key' => speech_key,
        'Content-Type' => 'audio/wav'
      }
  
      # Make the API request
      response = RestClient.post(
          api_endpoint,
          File.read(audio_file.tempfile.path),
          headers
        )
  
      # Process the response as needed
      render json: { transcription: response.body }, status: :ok
      result = JSON.parse(response.body)
      @transcription = result["DisplayText"] || 'Unable to transcribe'
      respond_to do |format|
        format.html
        format.json { render json: { transcription: @transcription }, status: :ok }
        format.js  # Add this line to handle JavaScript response
      end
    else 
      render json: { error: 'Audio file is required' }, status: :unprocessable_entity
    end
  rescue RestClient::ExceptionWithResponse => e
    # Handle API request errors
    render json: { error: e.response.body }, status: e.http_code
  end
  

  # def speech_to_text
  #   subscription_key = ENV["AZURE_SUBSCRIPTION_KEY"]
  #   region = ENV["REGION"] 
  #   endpoint = "https://#{region}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1"

  #   audio_file_path = params[:audio_file].tempfile.path
  #   wav_file_path = convert_mp3_to_wav(audio_file_path)

  #   headers = {
  #     'Content-Type' => 'audio/wav',
  #     'Authorization' => "Bearer #{get_access_token(subscription_key, region)}"
  #   }
  #   puts "Request Headers: #{headers}"

  #   begin
  #     puts "WAV file path: #{wav_file_path}"
  #     response = RestClient.post(
  #       endpoint,
  #       File.read(audio_file_path),
  #       headers
  #     )

  #     result = JSON.parse(response.body)
  #     @transcription = result['DisplayText'] || 'Unable to transcribe'

  #     # Your implementation here
  #     respond_to do |format|
  #       format.html
  #       format.turbo_stream { render turbo_stream: turbo_stream.update('transcriptionResult', partial: 'display_transcription', locals: { transcription: @transcription }) }
  #     end
  #   rescue RestClient::ExceptionWithResponse => e
  #     render json: { error: "Speech-to-Text failed: #{e.message}" }, status: e.http_code
  #   ensure
  #     # Clean up the temporary WAV file
  #     File.delete(wav_file_path) if File.exist?(wav_file_path)
  #   end
  # end

  private

  def convert_mp3_to_wav(mp3_file_path)
    wav_file_path = "#{Rails.root}/tmp/#{SecureRandom.hex}.wav"
    system("ffmpeg -i #{mp3_file_path} -acodec pcm_s16le -ar 16000 #{wav_file_path}")
    wav_file_path
  end
  
  

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