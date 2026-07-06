import '../constants/karachi_dictionary.dart';

DictionaryEntry? dictionaryEntryForCraving(String craving) {
  final q = craving.toLowerCase();
  for (final e in karachiDictionary) {
    if (e.term.toLowerCase().contains(q) || q.contains(e.term.toLowerCase())) {
      return e;
    }
  }
  return null;
}
