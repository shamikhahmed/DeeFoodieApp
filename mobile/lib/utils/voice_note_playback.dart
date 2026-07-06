import 'dart:async';

import 'voice_note_playback_export.dart';

abstract class VoiceNotePlayback {
  bool get ready;
  bool get playing;
  String? get error;
  Stream<void> get onComplete;

  Future<void> prepare(String dataUrl);
  Future<void> play();
  Future<void> pause();
  Future<void> dispose();
}

VoiceNotePlayback createVoiceNotePlayback() => createVoiceNotePlaybackImpl();
