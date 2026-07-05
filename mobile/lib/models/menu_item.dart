class MenuItem {
  const MenuItem({required this.name, required this.price});

  final String name;
  final double price;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class EateryMenu {
  const EateryMenu({required this.effectiveYear, required this.items});

  final int effectiveYear;
  final List<MenuItem> items;

  factory EateryMenu.fromJson(Map<String, dynamic> json) {
    return EateryMenu(
      effectiveYear: json['effectiveYear'] as int? ?? 2025,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
