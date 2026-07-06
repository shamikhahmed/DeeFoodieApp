import '../models/eatery.dart';

enum PriceBand { budget, mid, splurge }

double? _anchorPrice(Eatery e) {
  if (e.mustTryPrice != null && e.mustTryPrice! > 0) return e.mustTryPrice;
  final menu = e.menu;
  if (menu == null || menu.items.isEmpty) return null;
  final prices = menu.items.map((i) => i.price).where((p) => p > 0);
  if (prices.isEmpty) return null;
  return prices.reduce((a, b) => a < b ? a : b);
}

PriceBand? priceBandForEatery(Eatery e) {
  final price = _anchorPrice(e);
  if (price == null) return null;
  if (price < 500) return PriceBand.budget;
  if (price <= 1500) return PriceBand.mid;
  return PriceBand.splurge;
}

String priceBandLabel(PriceBand band) => switch (band) {
      PriceBand.budget => 'Budget',
      PriceBand.mid => 'Mid-range',
      PriceBand.splurge => 'Splurge',
    };
