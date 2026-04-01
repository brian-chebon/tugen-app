import 'package:flutter_tts/flutter_tts.dart';

import 'tts_service.dart';

TtsService createTtsService() => _NativeTtsService();

class _NativeTtsService implements TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    // Default to Swahili Kenya — closest to Tugen pronunciation
    await _tts.setLanguage('sw-KE');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  @override
  Future<void> speak(
    String text, {
    double rate = 0.4,
    String language = 'sw-KE',
  }) async {
    await _init();
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(rate);
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  void dispose() {
    _tts.stop();
  }
}
