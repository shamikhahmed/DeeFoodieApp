import 'package:flutter/material.dart';
import 'section_header.dart';

class HorizontalSection extends StatelessWidget {
  const HorizontalSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.actionLabel,
    this.onAction,
    this.height = 200,
  });

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title, actionLabel: actionLabel, onAction: onAction),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
