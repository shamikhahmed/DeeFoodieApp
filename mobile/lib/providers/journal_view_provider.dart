import 'package:flutter_riverpod/flutter_riverpod.dart';

enum JournalViewMode { timeline, book }

class JournalViewNotifier extends Notifier<JournalViewMode> {
  @override
  JournalViewMode build() => JournalViewMode.book;

  void toggle() => state = state == JournalViewMode.timeline ? JournalViewMode.book : JournalViewMode.timeline;
  void set(JournalViewMode mode) => state = mode;
}

final journalViewModeProvider = NotifierProvider<JournalViewNotifier, JournalViewMode>(JournalViewNotifier.new);
