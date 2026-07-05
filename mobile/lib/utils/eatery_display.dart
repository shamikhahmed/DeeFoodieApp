import 'package:intl/intl.dart';
import '../models/eatery.dart';
import '../models/menu_item.dart';
import '../models/visit.dart';

double displayRating(Eatery eatery) => eatery.avgRating ?? 0;

bool hasDisplayRating(Eatery eatery) => (eatery.avgRating ?? 0) > 0;

({String name, double price})? mustTryItem(Eatery eatery) {
  if (eatery.mustTryName != null && eatery.mustTryPrice != null) {
    return (name: eatery.mustTryName!, price: eatery.mustTryPrice!);
  }
  final fromMenu = _pickFromMenu(eatery.menu?.items ?? []);
  if (fromMenu != null) return fromMenu;
  return null;
}

({String name, double price})? mustTryFromVisits(Eatery eatery, List<Visit> visits) {
  final here = visits.where((v) => v.eateryId == eatery.id);
  for (final v in here) {
    if (v.favoriteItem != null && v.favoriteItem!.isNotEmpty) {
      final menu = eatery.menu?.items ?? [];
      final match = menu.where((m) => m.name.toLowerCase() == v.favoriteItem!.toLowerCase());
      if (match.isNotEmpty) {
        return (name: match.first.name, price: match.first.price);
      }
      return (name: v.favoriteItem!, price: 0);
    }
  }
  return mustTryItem(eatery);
}

({String name, double price})? _pickFromMenu(List<MenuItem> items) {
  if (items.isEmpty) return null;
  final food = items.where((m) => !_isDrink(m.name)).toList();
  final pool = food.isNotEmpty ? food : items;
  final idx = pool.length ~/ 2;
  final item = pool[idx.clamp(0, pool.length - 1)];
  return (name: item.name, price: item.price);
}

bool _isDrink(String name) {
  final n = name.toLowerCase();
  return n.contains('chai') ||
      n.contains('latte') ||
      n.contains('coffee') ||
      n.contains('juice') ||
      n.contains('soda') ||
      n.contains('lassi') ||
      n.contains('tea');
}

final _priceFormat = NumberFormat('#,##0', 'en_US');

String formatRs(double price) {
  if (price <= 0) return '';
  return 'Rs ${_priceFormat.format(price.round())}';
}

String? reviewSnippet(String? text, {int maxLen = 72}) {
  if (text == null || text.trim().isEmpty) return null;
  final t = text.trim();
  if (t.length <= maxLen) return t;
  return '${t.substring(0, maxLen).trim()}…';
}
