
import '../pages.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to chat screen
          Navigator.pushNamed(context, '/chat');
        },
        child: const Icon(Icons.chat),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Featured Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SwiperWidget(products: productsList),
            ),
            const SizedBox(height: 16),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const CategoriesWidget(),
            const SizedBox(height: 16),
            Expanded(
              child: ProductsGrid(products: productsList),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
            // Navigate to Categories page
              Navigator.pushReplacementNamed(context, '/categories');
              break;
            case 1:
            // Navigate to Product page
              Navigator.pushReplacementNamed(context, '/products');
              break;
            case 2:
            // Navigate to Cart page
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 3:
            // Navigate to Profile page
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

class SwiperWidget extends StatefulWidget {
  final List<Product> products;

  const SwiperWidget({super.key, required this.products});

  @override
  _SwiperWidgetState createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.products[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildIndicator(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIndicator() {
    return List.generate(
      widget.products.length,
          (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: CircleAvatar(
          radius: 5,
          backgroundColor:
          index == _currentIndex ? Colors.blue : Colors.grey[400],
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryItem(name: 'Electronics', icon: Icons.electrical_services),
          CategoryItem(name: 'Fashion', icon: Icons.checkroom),
          CategoryItem(name: 'Home', icon: Icons.home),
          CategoryItem(name: 'Beauty', icon: Icons.brush),
          CategoryItem(name: 'Toys', icon: Icons.toys),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const CategoryItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        avatar: Icon(icon, size: 20),
        label: Text(name),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  const ProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return ProductItem(product: products[index]);
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
