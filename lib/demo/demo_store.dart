import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoProduct {
  final String id, name, category, image, description;
  final int price, stock;
  const DemoProduct(this.id, this.name, this.category, this.price, this.stock,
      this.image, this.description);
}

const demoProducts = [
  DemoProduct(
      'mouse',
      'RGB Gaming Mouse',
      'Peripherals',
      4200,
      8,
      'product1.jpg',
      'A comfortable wired gaming mouse for everyday work and play. Adjustable sensitivity and customisable lighting.'),
  DemoProduct('oled', 'ROG OLED Display', 'Displays', 89000, 4, 'product2.jpg',
      'Bring your setup to life with vivid colour and a crisp, expansive display. A sample premium monitor from the original TekVend catalogue.'),
  DemoProduct(
      'keyboard',
      'Keyboard & Mouse Combo',
      'Peripherals',
      3500,
      12,
      'product3.jpg',
      'A colourful keyboard and mouse set to complete your first gaming desk. Wired connections keep setup simple.'),
  DemoProduct(
      'psu',
      'Corsair RGB Power Supply',
      'Components',
      7800,
      6,
      'product4.jpg',
      'A modular power supply for your next desktop build, with an RGB fan and flexible cable management.'),
  DemoProduct(
      'desktop',
      'Performance Desktop',
      'Desktops',
      115000,
      3,
      'product5.jpg',
      'A showcase desktop with a glass side panel, room for upgrades, and a cooling-focused layout.'),
  DemoProduct(
      'cooler',
      'TUF Liquid Cooler',
      'Components',
      12500,
      7,
      'product6.jpg',
      'A dual-fan liquid cooling kit for a quieter, cooler build. Check compatibility with your CPU and case before buying.'),
  DemoProduct(
      'allinone',
      'Everyday All-in-One',
      'Desktops',
      54000,
      5,
      'product7.jpg',
      'A tidy all-in-one workspace with a display, keyboard, and mouse. Designed for study, browsing, and everyday tasks.'),
  DemoProduct(
      'board',
      'ROG Strix Motherboard',
      'Components',
      26500,
      5,
      'product8.jpg',
      'The foundation of a custom desktop. Match your processor, memory, and case with the correct motherboard specification.'),
];

class DemoStore extends ChangeNotifier {
  final SharedPreferences preferences;
  final Map<String, int> cart = {};
  final Set<String> favorites = {};
  final List<Map<String, dynamic>> orders = [];
  String name = 'Guest', address = '';
  static const storageKey = 'tekvend.demo.v2';
  DemoStore._(this.preferences);
  static Future<DemoStore> load() async {
    final store = DemoStore._(await SharedPreferences.getInstance());
    try {
      final data = jsonDecode(store.preferences.getString(storageKey) ?? '{}')
          as Map<String, dynamic>;
      final savedCart = Map<String, dynamic>.from(data['cart'] ?? {});
      for (final product in demoProducts) {
        final quantity = savedCart[product.id];
        if (quantity is num && quantity > 0)
          store.cart[product.id] = quantity.toInt().clamp(1, product.stock);
      }
      store.favorites.addAll(List<String>.from(data['favorites'] ?? [])
          .where((id) => demoProducts.any((product) => product.id == id)));
      store.orders.addAll(List<Map<String, dynamic>>.from(
          (data['orders'] as List? ?? [])
              .map((order) => Map<String, dynamic>.from(order))));
      store.name = data['name'] is String ? data['name'] : 'Guest';
      store.address = data['address'] is String ? data['address'] : '';
    } catch (_) {
      /* Ignore corrupt local demo state; the catalogue stays usable. */
    }
    return store;
  }

  DemoProduct product(String id) =>
      demoProducts.firstWhere((product) => product.id == id);
  int get count => cart.values.fold(0, (sum, quantity) => sum + quantity);
  int get subtotal => cart.entries
      .fold(0, (sum, item) => sum + product(item.key).price * item.value);
  Future<void> persist() => preferences.setString(
      storageKey,
      jsonEncode({
        'cart': cart,
        'favorites': favorites.toList(),
        'orders': orders,
        'name': name,
        'address': address
      }));
  void changed() {
    notifyListeners();
    persist();
  }

  bool add(String id) {
    final quantity = cart[id] ?? 0;
    if (quantity >= product(id).stock) return false;
    cart[id] = quantity + 1;
    changed();
    return true;
  }

  void quantity(String id, int value) {
    if (value <= 0) {
      cart.remove(id);
    } else {
      cart[id] = value.clamp(1, product(id).stock);
    }
    changed();
  }

  void favorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    changed();
  }

  void profile(String nextName, String nextAddress) {
    name = nextName.trim().isEmpty ? 'Guest' : nextName.trim();
    address = nextAddress.trim();
    changed();
  }

  Future<Map<String, dynamic>> checkout(String delivery) async {
    if (cart.isEmpty) throw StateError('Your cart is empty.');
    if (delivery.trim().length < 8)
      throw StateError(
          'Enter a demo delivery address with at least 8 characters.');
    final order = <String, dynamic>{
      'id': 'TV-${DateTime.now().millisecondsSinceEpoch}',
      'date': DateTime.now().toIso8601String(),
      'total': subtotal,
      'address': delivery.trim(),
      'items': cart.entries
          .map((item) => {
                'name': product(item.key).name,
                'quantity': item.value,
                'price': product(item.key).price
              })
          .toList()
    };
    orders.insert(0, order);
    address = delivery.trim();
    cart.clear();
    notifyListeners();
    await persist();
    return order;
  }
}
