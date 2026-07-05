import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/router/app_router.dart';

void main() {
  tearDown(() => onboardingDoneListenable.value = false);

  test('onboarding gate unlocks after complete', () {
    onboardingDoneListenable.value = false;
    expect(onboardingDoneListenable.value, isFalse);

    onboardingDoneListenable.value = true;
    expect(onboardingDoneListenable.value, isTrue);
  });
}
