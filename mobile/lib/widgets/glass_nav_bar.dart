import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final tokens = context.capTokens;
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.materialBar,
          border: Border(
            top: BorderSide(color: tokens.separator),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.inkBrown.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          height: 68,
          indicatorColor: tokens.accent.withValues(alpha: 0.16),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? tokens.accent : tokens.textSecondary,
                );
          }),
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) {
            HapticFeedback.selectionClick();
            onDestinationSelected(i);
          },
          destinations: destinations,
        ),
      ),
    );
  }
}
