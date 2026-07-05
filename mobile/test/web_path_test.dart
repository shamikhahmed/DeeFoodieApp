import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/utils/web_path.dart';

void main() {
  test('normalizeAppPath strips GitHub Pages prefix', () {
    expect(normalizeAppPath('/DeeFoodieApp/'), '/');
    expect(normalizeAppPath('/DeeFoodieApp/onboarding'), '/onboarding');
    expect(normalizeAppPath('/DeeFoodieApp/explore'), '/explore');
    expect(normalizeAppPath('/onboarding'), '/onboarding');
    expect(normalizeAppPath('/'), '/');
  });

  test('isOnboardingPath works with prefixed paths', () {
    expect(isOnboardingPath('/DeeFoodieApp/onboarding'), isTrue);
    expect(isOnboardingPath('/onboarding'), isTrue);
    expect(isOnboardingPath('/DeeFoodieApp/'), isFalse);
  });
}
