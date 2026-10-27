import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartController extends GetxController {
  var cartProducts = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cartItems') ?? [];
    cartProducts.value = cartItems.map((item) => json.decode(item) as Map<String, dynamic>).toList();
    updateTotalPrice();
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = cartProducts.map((item) => json.encode(item)).toList();
    await prefs.setStringList('cartItems', cartItems);
  }

  void addProduct(Map<String, dynamic> product) {
    final key = product['id'] ?? product['name'];
    final existing = cartProducts.indexWhere((item) => (item['id'] ?? item['name']) == key);
    final quantity = ((product['quantity'] as num?)?.toInt() ?? 1).clamp(1, 99);
    if (existing >= 0) {
      cartProducts[existing]['quantity'] = (((cartProducts[existing]['quantity'] as num?)?.toInt() ?? 1) + quantity).clamp(1, 99);
      cartProducts.refresh();
    } else {
      cartProducts.add({ ...product, 'quantity': quantity });
    }
    updateTotalPrice();
    saveCartItems();
  }

  void removeProduct(int index) {
    cartProducts.removeAt(index);
    updateTotalPrice();
    saveCartItems();
  }

  void updateProductQuantity(int index, int quantity) {
    if (index < 0 || index >= cartProducts.length) return;
    if (quantity <= 0) { removeProduct(index); return; }
    cartProducts[index]['quantity'] = quantity.clamp(1, 99);
    cartProducts.refresh();
    updateTotalPrice();
    saveCartItems();
  }

  void updateTotalPrice() {
    totalPrice.value = cartProducts.fold(
      0.0,
          (sum, item) => sum + ((item['price'] as num?)?.toDouble() ?? 0) * ((item['quantity'] as num?)?.toInt() ?? 1),
    );
  }
}
