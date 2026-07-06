import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'voice_note_playback.dart';

VoiceNotePlayback createVoiceNotePlaybackImpl() => _AudioplayersVoiceNote();

class _AudioplayersVoiceNote implements VoiceNotePlayback {
  final _player = AudioPlayer();
  final _complete = StreamController<void>.broadcast();

  @override
  bool ready = false;

  @override
  bool playing = false;

  @override
  String? error;

  @override
  Stream<void> get onComplete => _complete.stream;

  _AudioplayersVoiceNote() {
    _player.onPlayerComplete.listen((_) {
      playing = false;
      _complete.add(null);
    });
  }

  @override
  Future<void> prepare(String dataUrl) async {
    try {
      final uri = Uri.parse(dataUrl);
      if (uri.scheme == 'data') {
        final bytes = base64Decode(uri.data!.contentText);
        final mime = _normalizeMime(uri.data?.mimeType ?? 'audio/mp4');
        await _player.setSource(BytesSource(bytes, mimeType: mime));
      } else {
        await _player.setSource(UrlSource(dataUrl));
      }
      ready = true;
    } catch (e) {
      error = 'Playback unavailable';
      ready = false;
    }
  }

  @override
  Future<void> play() async {
    if (!ready) return;
    await _player.resume();
    playing = true;
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    playing = false;
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _complete.close();
  }

  String _normalizeMime(String mime) {
    if (mime == 'audio/m4a' || mime == 'audio/x-m4a') return 'audio/mp4';
    return mime;
  }
}
