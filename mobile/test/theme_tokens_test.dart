import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/theme/app_theme.dart';
import 'package:deefoodie_app/theme/cap_tokens.dart';

void main() {
  testWidgets('CapTokens ThemeExtension is available (FND-05)', (tester) async {
    late CapTokens tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Builder(
          builder: (context) {
            tokens = context.capTokens;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(tokens.accent, CapTokens.light.accent);
    expect(tokens.rowMinHeight, 44);
  });

  testWidgets('text scale 1.0 / 1.3 / 2.0 builds without overflow on Home title style', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: MaterialApp(
            theme: buildAppTheme(),
            home: Scaffold(
              body: Builder(
                builder: (context) => Text(
                  'Your Karachi',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Your Karachi'), findsOneWidget);
    }
  });
}
