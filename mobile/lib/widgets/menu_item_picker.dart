import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';

class SelectedMenuItem {
  const SelectedMenuItem({required this.name, required this.price, this.type = 'food'});

  final String name;
  final double price;
  final String type;
}

class MenuItemPicker extends StatelessWidget {
  const MenuItemPicker({
    super.key,
    required this.menuItems,
    required this.selected,
    required this.onChanged,
    this.title,
  });

  final List<MenuItem> menuItems;
  final List<SelectedMenuItem> selected;
  final ValueChanged<List<SelectedMenuItem>> onChanged;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (menuItems.isEmpty) {
      return GlassSurface(
        child: Text(
          'No menu on file yet — add items manually below.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Text(title!, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
        ],
        GlassSurface(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Column(
            children: menuItems.map((item) {
              final isOn = selected.any((s) => s.name == item.name);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    final next = List<SelectedMenuItem>.from(selected);
                    if (isOn) {
                      next.removeWhere((s) => s.name == item.name);
                    } else {
                      next.add(SelectedMenuItem(name: item.name, price: item.price, type: _itemType(item.name)));
                    }
                    onChanged(next);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Row(
                      children: [
                        Icon(
                          isOn ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isOn ? AppColors.darkGreen : AppColors.textMuted,
                          size: 22,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(item.name, style: Theme.of(context).textTheme.bodyMedium)),
                        Text(formatRs(item.price), style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (selected.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Subtotal ${formatRs(selected.fold<double>(0, (s, i) => s + i.price))}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.coffeeBrown),
            ),
          ),
        ],
      ],
    );
  }

  static String _itemType(String name) {
    final n = name.toLowerCase();
    if (n.contains('chai') || n.contains('coffee') || n.contains('lassi') || n.contains('juice') || n.contains('soda') || n.contains('drink') || n.contains('latte')) {
      return 'drink';
    }
    if (n.contains('kulfi') || n.contains('brownie') || n.contains('rabri') || n.contains('jamun') || n.contains('malai') || n.contains('falooda') || n.contains('cake') || n.contains('dessert')) {
      return 'dessert';
    }
    return 'food';
  }
}
