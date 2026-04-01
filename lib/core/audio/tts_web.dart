import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'tts_service.dart';

TtsService createTtsService() => _WebTtsService();

class _WebTtsService implements TtsService {
  web.SpeechSynthesisVoice? _cachedVoice;
  bool _voiceSearched = false;

  /// Find the best voice for Tugen text.
  /// Priority: sw-KE (Swahili Kenya) > sw (any Swahili) > af (Afrikaans) > default
  web.SpeechSynthesisVoice? _findBestVoice() {
    if (_voiceSearched) return _cachedVoice;
    _voiceSearched = true;

    final voices = web.window.speechSynthesis.getVoices().toDart;
    if (voices.isEmpty) return null;

    // Try Swahili Kenya first (closest to Tugen pronunciation)
    for (final voice in voices) {
      if (voice.lang.startsWith('sw-KE')) {
        _cachedVoice = voice;
        return _cachedVoice;
      }
    }
    // Try any Swahili voice
    for (final voice in voices) {
      if (voice.lang.startsWith('sw')) {
        _cachedVoice = voice;
        return _cachedVoice;
      }
    }
    // Try Afrikaans as fallback (African phonetics)
    for (final voice in voices) {
      if (voice.lang.startsWith('af')) {
        _cachedVoice = voice;
        return _cachedVoice;
      }
    }
    return null;
  }

  @override
  Future<void> speak(
    String text, {
    double rate = 0.5,
    String language = 'sw-KE',
  }) async {
    final synth = web.window.speechSynthesis;
    synth.cancel();

    final utterance = web.SpeechSynthesisUtterance(text);
    utterance.rate = rate;
    utterance.volume = 1.0;

    // Try to set an explicit African voice for natural pronunciation
    final voice = _findBestVoice();
    if (voice != null) {
      utterance.voice = voice;
    } else {
      // Fall back to language hint (browser picks best match)
      utterance.lang = language;
    }

    synth.speak(utterance);
  }

  @override
  Future<void> stop() async {
    web.window.speechSynthesis.cancel();
  }

  @override
  void dispose() {
    web.window.speechSynthesis.cancel();
  }
}
