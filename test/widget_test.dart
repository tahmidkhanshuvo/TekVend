import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amar/demo/demo_app.dart';
import 'package:amar/demo/demo_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('cart survives reload, respects stock, and never accepts negative quantities', () async {
    final store = await DemoStore.load();
    for (var i = 0; i < 20; i++) {
      store.add('mouse');
    }
    expect(store.cart['mouse'], store.product('mouse').stock);
    expect(store.add('mouse'), isFalse);
    await store.persist();
    final restored = await DemoStore.load();
    expect(restored.count, 8);
    restored.quantity('mouse', -1);
    expect(restored.cart, isEmpty);
  });
  test('demo checkout requires an address and stores a receipt before clearing the cart', () async {
    final store = await DemoStore.load();
    store.add('mouse');
    store.add('keyboard');
    await expectLater(store.checkout(''), throwsStateError);
    expect(store.cart.length, 2);
    final receipt = await store.checkout('Demo Campus Gate, Dhaka');
    expect(receipt['total'], 7700);
    expect(store.cart, isEmpty);
    final restored = await DemoStore.load();
    expect(restored.orders.single['id'], receipt['id']);
    expect(restored.orders.single['items'].length, 2);
  });
  test(
    'saved products and profile persist independently of the cart',
    () async {
      final store = await DemoStore.load();
      store.favorite('oled');
      store.profile('Demo visitor', 'Example Campus, Dhaka');
      await store.persist();
      final restored = await DemoStore.load();
      expect(restored.favorites, contains('oled'));
      expect(restored.name, 'Demo visitor');
    },
  );
  test('reset clears only TekVend demo data and persists the reset', () async {
    final store = await DemoStore.load();
    await store.preferences.setString('unrelated-preference', 'keep');
    store.add('mouse');
    store.favorite('oled');
    await store.checkout('QA Demo Address');
    await store.resetDemo();
    final restored = await DemoStore.load();
    expect(restored.cart, isEmpty);
    expect(restored.orders, isEmpty);
    expect(restored.favorites, isEmpty);
    expect(restored.name, 'Guest');
    expect(restored.address, isEmpty);
    expect(store.preferences.getString('unrelated-preference'), 'keep');
  });
  testWidgets('demo renders a usable storefront without Firebase', (
    tester,
  ) async {
    await tester.pumpWidget(const TekVendDemo());
    await tester.pumpAndSettle();
    expect(find.text('Find your next upgrade'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Search products…'), findsOneWidget);
    expect(find.textContaining('No real payments'), findsOneWidget);
  });
}
