import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/voice_note_playback.dart';

class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({super.key, required this.dataUrl, this.compact = false});

  final String dataUrl;
  final bool compact;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  late final VoiceNotePlayback _playback = createVoiceNotePlayback();
  StreamSubscription<void>? _completeSub;

  @override
  void initState() {
    super.initState();
    _completeSub = _playback.onComplete.listen((_) {
      if (mounted) setState(() {});
    });
    _prepare();
  }

  Future<void> _prepare() async {
    await _playback.prepare(widget.dataUrl);
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    if (!_playback.ready) return;
    if (_playback.playing) {
      await _playback.pause();
    } else {
      await _playback.play();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _completeSub?.cancel();
    _playback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_playback.error != null) {
      return Text(
        _playback.error!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
      );
    }

    final label = _playback.playing ? 'Pause voice' : 'Play voice memory';

    if (widget.compact) {
      return InkWell(
        onTap: _playback.ready ? _toggle : null,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _playback.playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
              size: 22,
              color: AppColors.coffeeBrown,
            ),
            const SizedBox(width: 6),
            Text(
              _playback.ready ? label : 'Loading voice…',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.coffeeBrown),
            ),
          ],
        ),
      );
    }

    return FilledButton.tonalIcon(
      onPressed: _playback.ready ? _toggle : null,
      icon: Icon(_playback.playing ? Icons.pause : Icons.play_arrow),
      label: Text(_playback.ready ? label : 'Loading voice…'),
      style: FilledButton.styleFrom(foregroundColor: AppColors.coffeeBrown),
    );
  }
}
