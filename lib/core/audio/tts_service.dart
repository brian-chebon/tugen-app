/// Platform-agnostic TTS interface
abstract class TtsService {
  Future<void> speak(String text, {double rate, String language});
  Future<void> stop();
  void dispose();
}
