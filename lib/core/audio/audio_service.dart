import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tts_service.dart';
import 'tts_stub.dart'
    if (dart.library.html) 'tts_web.dart'
    if (dart.library.io) 'tts_native.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Centralized audio service for phrase playback, story streaming, and caching
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  late final TtsService _tts = createTtsService();
  final Dio _dio = Dio();
  final Logger _log = Logger();

  AudioPlayer get player => _player;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;

  /// Play audio from local file or remote URL with automatic caching.
  /// Falls back to TTS if no audio source is available.
  /// Pass [ttsText] to speak via TTS when no recorded audio exists.
  Future<void> play(
    String audioPath, {
    String? remoteUrl,
    String? ttsText,
  }) async {
    try {
      if (!kIsWeb &&
          audioPath.isNotEmpty &&
          await File(audioPath).exists()) {
        await _player.setFilePath(audioPath);
        await _player.play();
      } else if (remoteUrl != null && remoteUrl.isNotEmpty) {
        await _player.setUrl(remoteUrl);
        if (!kIsWeb) _cacheInBackground(remoteUrl, audioPath);
        await _player.play();
      } else if (ttsText != null && ttsText.isNotEmpty) {
        await _tts.speak(ttsText);
      } else {
        _log.w('No audio source available');
      }
    } catch (e) {
      _log.e('Audio playback error', error: e);
      // If primary playback fails, try TTS as last resort
      if (ttsText != null && ttsText.isNotEmpty) {
        try {
          await _tts.speak(ttsText);
        } catch (_) {}
      }
    }
  }

  /// Speak text using TTS engine
  Future<void> speak(String text, {String? language}) async {
    await _tts.speak(text, language: language ?? 'en-US');
  }

  /// Stop TTS playback
  Future<void> stopTts() async {
    await _tts.stop();
  }

  /// Play a clip (segment of audio) — used for story segments
  Future<void> playClip(
    String audioPath, {
    String? remoteUrl,
    required Duration start,
    required Duration end,
  }) async {
    try {
      if (!kIsWeb &&
          audioPath.isNotEmpty &&
          await File(audioPath).exists()) {
        await _player.setFilePath(audioPath);
      } else if (remoteUrl != null) {
        await _player.setUrl(remoteUrl);
      }
      await _player.setClip(start: start, end: end);
      await _player.play();
    } catch (e) {
      _log.e('Clip playback error', error: e);
    }
  }

  /// Replay current audio from start
  Future<void> replay() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  /// Set playback speed (0.5x to 2.0x)
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed.clamp(0.5, 2.0));
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  /// Download audio file to local storage (no-op on web)
  Future<String> downloadAudio(
    String url,
    String fileName, {
    void Function(int, int)? onProgress,
  }) async {
    if (kIsWeb) return '';

    final dir = await _getAudioCacheDir();
    final filePath = p.join(dir.path, fileName);
    final file = File(filePath);

    if (await file.exists()) return filePath;

    try {
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: onProgress,
      );
      return filePath;
    } catch (e) {
      _log.e('Download failed: $url', error: e);
      rethrow;
    }
  }

  /// Download all audio for a category/deck (batch)
  Future<void> downloadBatch(
    List<({String url, String fileName})> items, {
    void Function(int completed, int total)? onProgress,
  }) async {
    if (kIsWeb) return;
    for (var i = 0; i < items.length; i++) {
      await downloadAudio(items[i].url, items[i].fileName);
      onProgress?.call(i + 1, items.length);
    }
  }

  /// Get total cache size in bytes
  Future<int> getCacheSize() async {
    if (kIsWeb) return 0;
    final dir = await _getAudioCacheDir();
    if (!await dir.exists()) return 0;
    int size = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size;
  }

  /// Clear audio cache
  Future<void> clearCache() async {
    if (kIsWeb) return;
    final dir = await _getAudioCacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<Directory> _getAudioCacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(p.join(appDir.path, 'audio_cache'));
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  void _cacheInBackground(String url, String localPath) async {
    try {
      if (localPath.isEmpty) return;
      final file = File(localPath);
      if (await file.exists()) return;

      await file.parent.create(recursive: true);
      await _dio.download(url, localPath);
    } catch (e) {
      _log.w('Background caching failed: $url');
    }
  }

  void dispose() {
    _player.dispose();
    _tts.dispose();
  }
}
