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
    cartProducts.add(product);
    updateTotalPrice();
    saveCartItems();
  }

  void removeProduct(int index) {
    cartProducts.removeAt(index);
    updateTotalPrice();
    saveCartItems();
  }

  void updateProductQuantity(int index, int quantity) {
    cartProducts[index]['quantity'] = quantity;
    updateTotalPrice();
    saveCartItems();
  }

  void updateTotalPrice() {
    totalPrice.value = cartProducts.fold(
      0.0,
          (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }
}
