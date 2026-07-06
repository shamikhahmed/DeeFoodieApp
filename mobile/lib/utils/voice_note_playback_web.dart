import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'voice_note_playback.dart';

VoiceNotePlayback createVoiceNotePlaybackImpl() => _WebVoiceNote();

class _WebVoiceNote implements VoiceNotePlayback {
  html.AudioElement? _audio;
  String? _objectUrl;
  final _complete = StreamController<void>.broadcast();

  @override
  bool ready = false;

  @override
  bool playing = false;

  @override
  String? error;

  @override
  Stream<void> get onComplete => _complete.stream;

  @override
  Future<void> prepare(String dataUrl) async {
    try {
      _revoke();
      final uri = Uri.parse(dataUrl);
      late final String src;
      if (uri.scheme == 'data') {
        final bytes = base64Decode(uri.data!.contentText);
        final mime = _normalizeMime(uri.data?.mimeType ?? 'audio/mp4');
        final blob = html.Blob([bytes], mime);
        _objectUrl = html.Url.createObjectUrl(blob);
        src = _objectUrl!;
      } else {
        src = dataUrl;
      }
      final audio = html.AudioElement(src);
      audio.preload = 'auto';
      audio.onEnded.listen((_) {
        playing = false;
        _complete.add(null);
      });
      audio.onError.listen((_) {
        error = 'Playback unavailable';
        ready = false;
      });
      _audio = audio;
      await audio.onCanPlay.first.timeout(const Duration(seconds: 8));
      ready = true;
    } catch (e) {
      error = 'Playback unavailable';
      ready = false;
    }
  }

  @override
  Future<void> play() async {
    if (_audio == null || !ready) return;
    await _audio!.play();
    playing = true;
  }

  @override
  Future<void> pause() async {
    _audio?.pause();
    playing = false;
  }

  @override
  Future<void> dispose() async {
    _audio?.pause();
    _revoke();
    await _complete.close();
  }

  void _revoke() {
    if (_objectUrl != null) {
      html.Url.revokeObjectUrl(_objectUrl!);
      _objectUrl = null;
    }
    _audio = null;
  }

  String _normalizeMime(String mime) {
    if (mime == 'audio/m4a' || mime == 'audio/x-m4a') return 'audio/mp4';
    return mime;
  }
}
