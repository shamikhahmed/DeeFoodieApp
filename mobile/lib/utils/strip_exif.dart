import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Re-encode JPEG/PNG without EXIF so GPS metadata is stripped (DFD-P1-05).
Uint8List stripExifGps(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;
  // encodeJpg does not copy EXIF/GPS from the source.
  return Uint8List.fromList(img.encodeJpg(decoded, quality: 85));
}
