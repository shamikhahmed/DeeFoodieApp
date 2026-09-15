import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deefoodie_app/theme/app_theme.dart';
import 'package:deefoodie_app/widgets/primary_button.dart';
import 'package:deefoodie_app/widgets/glass_nav_bar.dart';

/// C-21 finish-matrix analogue for Flutter: primary shell at phone widths × text scale.
void main() {
  const widths = [320.0, 375.0, 430.0];
  const scales = [1.0, 2.0];

  for (final width in widths) {
    for (final scale in scales) {
      testWidgets('shell · ${width.toInt()}w · textScale $scale', (tester) async {
        final view = tester.view;
        view.physicalSize = Size(width * 2, 800 * 2);
        view.devicePixelRatio = 2.0;
        addTearDown(view.resetPhysicalSize);
        addTearDown(view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(
              size: Size(width, 800),
              textScaler: TextScaler.linear(scale),
            ),
            child: MaterialApp(
              theme: buildAppTheme(),
              home: Scaffold(
                body: SafeArea(
                  child: Builder(
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Your Karachi',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: PrimaryButton(
                              label: 'Log a visit',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                bottomNavigationBar: GlassNavBar(
                  selectedIndex: 0,
                  onDestinationSelected: (_) {},
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.map_outlined),
                      label: 'Map',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      label: 'Journal',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      label: 'You',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Log a visit'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(tester.takeException(), isNull);

        final button = tester.getRect(find.byType(PrimaryButton));
        expect(button.left, greaterThanOrEqualTo(-0.5));
        expect(button.right, lessThanOrEqualTo(width + 0.5));
      });
    }
  }
}
