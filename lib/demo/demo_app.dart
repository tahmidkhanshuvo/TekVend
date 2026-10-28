import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'demo_store.dart';

const ink = Color(0xff202124),
    brandGreen = Color(0xff2e7d32),
    softGreen = Color(0xffe8f5e9),
    canvas = Colors.white;
String money(num value) => NumberFormat.currency(
  locale: 'en_BD',
  symbol: '৳ ',
  decimalDigits: 0,
).format(value);

class TekVendDemo extends StatefulWidget {
  const TekVendDemo({super.key});
  @override
  State<TekVendDemo> createState() => _TekVendDemoState();
}

class _TekVendDemoState extends State<TekVendDemo> {
  late final Future<DemoStore> store = DemoStore.load();
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TekVend — Find your next upgrade',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        primary: brandGreen,
        secondary: brandGreen,
        surface: canvas,
      ),
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe5e7eb)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffe5e7eb)),
        ),
      ),
    ),
    home: FutureBuilder<DemoStore>(
      future: store,
      builder: (context, result) => result.hasData
          ? DemoShop(store: result.data!)
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
  );
}

class DemoShop extends StatefulWidget {
  final DemoStore store;
  const DemoShop({super.key, required this.store});
  @override
  State<DemoShop> createState() => _DemoShopState();
}

class _DemoShopState extends State<DemoShop> {
  int tab = 0;
  String category = 'All', query = '', sort = 'Featured';
  final search = TextEditingController();
  final question = TextEditingController();
  final messages = <Map<String, String>>[
    {
      'role': 'help',
      'text': 'Welcome! I can help you explore the catalogue, manage your cart, or try a demo checkout.',
    },
  ];
  DemoStore get store => widget.store;
  @override
  void dispose() {
    search.dispose();
    question.dispose();
    super.dispose();
  }

  void tell(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
  void add(DemoProduct product) {
    tell(
      store.add(product.id)
          ? '${product.name} added to your cart.'
          : 'You have reached the sample stock limit.',
    );
  }

  Widget heading(String text, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          color: ink,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: ink.withValues(alpha: .6),
        ),
      ),
    ],
  );
  Widget empty(String title, String subtitle, IconData icon) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 55),
    child: Center(
      child: Column(
        children: [
          Icon(icon, size: 52, color: ink.withValues(alpha: .35)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: ink.withValues(alpha: .6)),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => setState(() => tab = 0),
            child: const Text('Explore the catalogue'),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth > 800;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: canvas,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                InkWell(
                  onTap: () => setState(() => tab = 0),
                  child: Image.asset(
                    'lib/images/icon.png',
                    width: 150,
                    height: 64,
                    fit: BoxFit.cover,
                    semanticLabel: 'TekVend',
                  ),
                ),
                if (desktop) ...[
                  const Spacer(),
                  ...[
                    'Shop',
                    'Saved',
                    'Cart',
                    'Orders',
                    'Help',
                  ].asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: TextButton(
                        onPressed: () => setState(() => tab = entry.key),
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            color: tab == entry.key ? ink : Colors.grey,
                            fontWeight: tab == entry.key
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Your profile',
                onPressed: profile,
                icon: const Icon(Icons.person_outline),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Badge(
                  label: Text('${store.count}'),
                  isLabelVisible: store.count > 0,
                  child: IconButton(
                    tooltip: 'Open cart',
                    onPressed: () => setState(() => tab = 2),
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, color: Color(0xffe5e7eb)),
            ),
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: tab,
                  onDestinationSelected: (value) => setState(() => tab = value),
                  backgroundColor: Colors.white,
                  indicatorColor: softGreen,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      label: 'Shop',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      label: 'Saved',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.shopping_bag_outlined),
                      label: 'Cart',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.receipt_long_outlined),
                      label: 'Orders',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.chat_bubble_outline),
                      label: 'Help',
                    ),
                  ],
                ),
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1250),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    desktop ? 28 : 16,
                    24,
                    desktop ? 28 : 16,
                    40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: softGreen.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'INTERACTIVE DEMO  ·  Sample products and prices. No real payments or deliveries.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (tab == 0 || tab == 1)
                        catalogue(desktop, constraints.maxWidth)
                      else if (tab == 2)
                        cart(desktop)
                      else if (tab == 3)
                        orders()
                      else
                        help(),
                      const SizedBox(height: 60),
                      const Divider(color: Color(0xffe5e7eb)),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 30,
                        runSpacing: 12,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TekVend · Make your next upgrade count.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            'AUST CSE2104 · Flutter web demo',
                            style: TextStyle(
                              fontSize: 12,
                              color: ink.withValues(alpha: .5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
  Widget catalogue(bool desktop, double width) {
    final products = demoProducts
        .where(
          (product) =>
              (tab != 1 || store.favorites.contains(product.id)) &&
              (category == 'All' || product.category == category) &&
              '${product.name} ${product.category} ${product.description}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
        )
        .toList();
    if (sort == 'Price: low to high')
      products.sort((a, b) => a.price.compareTo(b.price));
    if (sort == 'Price: high to low')
      products.sort((a, b) => b.price.compareTo(a.price));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tab == 0) ...[
          SizedBox(
            height: desktop ? 270 : 230,
            child: PageView.builder(
              itemCount: desktop ? 2 : 5,
              itemBuilder: (context, page) => Row(
                children: List.generate(desktop ? 3 : 1, (column) {
                  final slide = (page * (desktop ? 3 : 1) + column) % 5 + 1;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'lib/images/slide$slide.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          semanticLabel:
                              'TekVend original product highlight $slide',
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Swipe through product highlights',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 28),
        ],
        heading(
          tab == 1 ? 'Your saved finds' : 'Find your next upgrade',
          tab == 1
              ? 'Keep the gear you like in one place.'
              : 'A small catalogue. Plenty of possibilities.',
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: desktop ? 330 : double.infinity,
              child: TextField(
                controller: search,
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: 'Search products…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            search.clear();
                            setState(() => query = '');
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
              ),
            ),
            DropdownMenu<String>(
              initialSelection: sort,
              label: const Text('Sort by'),
              dropdownMenuEntries:
                  ['Featured', 'Price: low to high', 'Price: high to low']
                      .map(
                        (value) =>
                            DropdownMenuEntry(value: value, label: value),
                      )
                      .toList(),
              onSelected: (value) => setState(() => sort = value!),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['All', 'Peripherals', 'Displays', 'Components', 'Desktops']
              .map(
                (value) => ChoiceChip(
                  label: Text(value),
                  selected: category == value,
                  onSelected: (_) => setState(() => category = value),
                  selectedColor: softGreen,
                  showCheckmark: false,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        if (products.isEmpty)
          empty(
            tab == 1 ? 'Nothing saved here yet' : 'No products found',
            tab == 1
                ? 'Tap a heart to save your next upgrade.'
                : 'Try another category or a different search.',
            tab == 1 ? Icons.favorite_border : Icons.search_off,
          )
        else
          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth < 560
                  ? 2
                  : box.maxWidth < 850
                  ? 3
                  : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: desktop ? 18 : 10,
                  mainAxisSpacing: 18,
                  childAspectRatio: box.maxWidth < 420 ? 0.57 : 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xffe5e7eb)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: InkWell(
                                  onTap: () => details(product),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                      'lib/images/${product.image}',
                                      fit: BoxFit.contain,
                                      semanticLabel: product.name,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  tooltip: store.favorites.contains(product.id)
                                      ? 'Remove from saved'
                                      : 'Save product',
                                  onPressed: () => store.favorite(product.id),
                                  icon: Icon(
                                    store.favorites.contains(product.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 21,
                                    color: ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 7),
                              SizedBox(
                                height: 42,
                                child: InkWell(
                                  onTap: () => details(product),
                                  child: Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                money(product.price),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => add(product),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Add to cart',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  void details(DemoProduct product) => showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    tooltip: 'Close product details',
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'lib/images/${product.image}',
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  product.description,
                  style: const TextStyle(height: 1.6, color: Colors.grey),
                ),
                const SizedBox(height: 18),
                Text(
                  '${product.stock} available in sample catalogue',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      money(product.price),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        add(product);
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Add to cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  Widget cart(bool desktop) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading('Your cart', 'A little closer to your next upgrade.'),
      const SizedBox(height: 28),
      if (store.cart.isEmpty)
        empty(
          'Your cart is taking a break',
          'Explore the catalogue and add something you love.',
          Icons.shopping_bag_outlined,
        )
      else ...[
        ...store.cart.entries.map((item) {
          final product = store.product(item.key);
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 18,
                runSpacing: 15,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/${product.image}',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: desktop ? 340 : 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          money(product.price),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Decrease quantity',
                        onPressed: () =>
                            store.quantity(item.key, item.value - 1),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${item.value}'),
                      IconButton(
                        tooltip: 'Increase quantity',
                        onPressed: item.value < product.stock
                            ? () => store.quantity(item.key, item.value + 1)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        money(product.price * item.value),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        tooltip: 'Remove item',
                        onPressed: () => store.quantity(item.key, 0),
                        icon: const Icon(Icons.close, size: 19),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffe5e7eb)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${store.count} items · ${money(store.subtotal)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Demo checkout only. No charge will be made.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: checkout,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Continue to demo checkout'),
              ),
            ],
          ),
        ),
      ],
    ],
  );
  void checkout() {
    final delivery = TextEditingController(text: store.address);
    String? error;
    bool busy = false;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: const Text('Complete your demo order'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${store.count} items · ${money(store.subtotal)}'),
                const SizedBox(height: 18),
                TextField(
                  controller: delivery,
                  maxLength: 300,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Demo delivery address',
                    hintText: 'Example: Campus Gate, Dhaka',
                    errorText: error,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'This is a simulation. No payment is collected and no parcel will be sent.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(dialogContext),
              child: const Text('Back to cart'),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      setDialog(() => busy = true);
                      try {
                        await store.checkout(delivery.text);
                        if (!mounted || !dialogContext.mounted) return;
                        Navigator.pop(dialogContext);
                        setState(() => tab = 3);
                        tell(
                          'Demo order placed. Find it in your order history.',
                        );
                      } catch (cause) {
                        setDialog(() {
                          error = cause.toString().replaceFirst(
                            'Bad state: ',
                            '',
                          );
                          busy = false;
                        });
                      }
                    },
              child: Text(busy ? 'Saving…' : 'Place demo order'),
            ),
          ],
        ),
      ),
    ).then((_) => delivery.dispose());
  }

  Widget orders() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading('Your orders', 'Every upgrade starts with a small decision.'),
      const SizedBox(height: 28),
      if (store.orders.isEmpty)
        empty(
          'No orders yet',
          'Try a demo checkout to see your receipt here.',
          Icons.receipt_long_outlined,
        )
      else
        ...store.orders.map(
          (order) => Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 18),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      Text(
                        order['id'],
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Chip(
                        label: Text(
                          'Demo order',
                          style: TextStyle(fontSize: 10),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('d MMM yyyy · HH:mm')
                        .format(DateTime.parse(order['date'])),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(height: 30),
                  ...List<Map<String, dynamic>>.from(order['items']).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('${item['quantity']} × ${item['name']}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total ${money(order['total'])}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demo address: ${order['address']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
  void profile() {
    final name = TextEditingController(
          text: store.name == 'Guest' ? '' : store.name,
        ),
        address = TextEditingController(text: store.address);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Your demo profile'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Personalise the demo. No account or password is needed.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: name,
                maxLength: 60,
                decoration: const InputDecoration(labelText: 'Display name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: address,
                maxLength: 300,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Demo delivery address',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              resetDemo();
            },
            child: const Text('Reset local demo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              store.profile(name.text, address.text);
              Navigator.pop(dialogContext);
              tell('Demo profile saved.');
            },
            child: const Text('Save profile'),
          ),
        ],
      ),
    ).then((_) {
      name.dispose();
      address.dispose();
    });
  }

  Future<void> resetDemo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset this browser demo?'),
        content: const Text(
          'Remove your local cart, saved products, demo receipts and profile. The sample catalogue stays available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep my data'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset demo'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await store.resetDemo();
    if (mounted) tell('Local demo data cleared.');
  }

  void ask() {
    final text = question.text.trim();
    if (text.isEmpty) return;
    final q = text.toLowerCase();
    final answer = q.contains('cart')
        ? 'Open Cart to change quantities or remove a product. Cart quantities are limited by the sample stock.'
        : q.contains('order') || q.contains('pay') || q.contains('checkout')
        ? 'Demo checkout creates a local receipt. No card details, real payments, or deliveries are involved. Open Orders to revisit your receipts.'
        : q.contains('component') || q.contains('build')
        ? 'Explore Components for the motherboard, power supply, and cooler. Match the CPU socket, memory type, case size, and power requirements before planning a real build.'
        : q.contains('save') || q.contains('favorite')
        ? 'Tap the heart on a product to save it. Open Saved to compare your favourites.'
        : 'Search by product name or category, sort by price, or open a product to learn more. Ask about carts, saved items, components, or demo orders.';
    setState(() {
      messages.add({'role': 'you', 'text': text});
      messages.add({'role': 'help', 'text': answer});
      question.clear();
    });
  }

  Widget help() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading(
        'A little help goes a long way',
        'Practical answers from the built-in TekVend demo guide.',
      ),
      const SizedBox(height: 25),
      ...messages.map(
        (message) => Align(
          alignment: message['role'] == 'you'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 760),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: message['role'] == 'you' ? softGreen : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message['text']!,
              style: const TextStyle(height: 1.6, fontSize: 14),
            ),
          ),
        ),
      ),
      const SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: question,
              maxLength: 1000,
              onSubmitted: (_) => ask(),
              decoration: const InputDecoration(
                hintText: 'Ask about your next upgrade…',
                counterText: '',
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            tooltip: 'Send question',
            onPressed: ask,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    ],
  );
}
