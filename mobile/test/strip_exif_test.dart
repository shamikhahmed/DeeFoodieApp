import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:deefoodie_app/utils/strip_exif.dart';

void main() {
  test('stripExifGps re-encodes JPEG without EXIF payload', () {
    final raw = img.Image(width: 8, height: 8);
    for (final p in raw) {
      p.r = 200;
      p.g = 100;
      p.b = 50;
    }
    final jpeg = Uint8List.fromList(img.encodeJpg(raw, quality: 90));
    final stripped = stripExifGps(jpeg);
    expect(stripped, isNotEmpty);
    // Re-decoded image must still load.
    expect(img.decodeImage(stripped), isNotNull);
    // EXIF APP1 marker should not appear after re-encode.
    expect(_hasExifApp1(stripped), isFalse);
  });
}

bool _hasExifApp1(Uint8List bytes) {
  // Look for APP1 (0xFFE1) followed by "Exif"
  for (var i = 0; i < bytes.length - 6; i++) {
    if (bytes[i] == 0xFF && bytes[i + 1] == 0xE1) {
      final slice = String.fromCharCodes(bytes.sublist(i + 4, i + 8));
      if (slice.startsWith('Exif')) return true;
    }
  }
  return false;
}
