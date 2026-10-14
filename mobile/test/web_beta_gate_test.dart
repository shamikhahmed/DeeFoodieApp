import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/services/web_beta_gate.dart';

void main() {
  group('WebBetaGate', () {
    test('rejects null empty and short tokens', () {
      expect(WebBetaGate.isValidToken(null), isFalse);
      expect(WebBetaGate.isValidToken(''), isFalse);
      expect(WebBetaGate.isValidToken('   '), isFalse);
      expect(WebBetaGate.isValidToken('short'), isFalse);
      expect(
        WebBetaGate.isValidToken('a' * (WebBetaGate.minTokenLength - 1)),
        isFalse,
      );
    });

    test('accepts 32+ character bearer', () {
      expect(
        WebBetaGate.isValidToken('a' * WebBetaGate.minTokenLength),
        isTrue,
      );
      expect(
        WebBetaGate.isValidToken('  ${'b' * 40}  '),
        isTrue,
      );
    });
  });
}
