require "test_helper"

class SpeechControllerTest < ActionDispatch::IntegrationTest
  test "should get text_to_speech" do
    get speech_text_to_speech_url
    assert_response :success
  end

  test "should get speech_to_text" do
    get speech_speech_to_text_url
    assert_response :success
  end
end
