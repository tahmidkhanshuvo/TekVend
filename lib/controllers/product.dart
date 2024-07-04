

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description; // New field for product details
  double discountPrice; // New field for product details
  List<String> specs; // New field for product details
  int stock; // New field for product details
  List<String> reviews; // New field for product details
  List<String> questions; // New field for product details
  int quantity; // Field used in the cart

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.discountPrice = 0,
    this.specs = const [],
    this.stock = 0,
    this.reviews = const [],
    this.questions = const [],
    this.quantity = 1,
  });
}



final List<Product> productsList = [
  Product(
    name: 'Product 1',
    description: 'Description of Product 1',
    price: 100.0,
    discountPrice: 80.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 10,
    reviews: ['Review 1: Good product!', 'Review 2: Excellent!'],
    questions: ['Question 1: How many colors?', 'Question 2: Waterproof?'],
    imageUrl: 'lib/images/product1.jpg',
  ),
  Product(
    name: 'Product 2',
    description: 'Description of Product 2',
    price: 120.0,
    discountPrice: 100.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 15,
    reviews: ['Review 1: Great product!', 'Review 2: Awesome!'],
    questions: ['Question 1: What materials?', 'Question 2: Warranty?'],
    imageUrl: 'lib/images/product2.jpg',
  ),
  Product(
    name: 'Product 3',
    description: 'Description of Product 3',
    price: 80.0,
    discountPrice: 70.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 20,
    reviews: ['Review 1: Nice product!', 'Review 2: Impressive!'],
    questions: ['Question 1: Size options?', 'Question 2: Return policy?'],
    imageUrl: 'lib/images/product3.jpg',
  ),
  Product(
    name: 'Product 4',
    description: 'Description of Product 4',
    price: 150.0,
    discountPrice: 120.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 12,
    reviews: ['Review 1: Solid product!', 'Review 2: Recommended!'],
    questions: ['Question 1: Shipping time?', 'Question 2: Assembly required?'],
    imageUrl: 'lib/images/product4.jpg',
  ),
  Product(
    name: 'Product 5',
    description: 'Description of Product 5',
    price: 200.0,
    discountPrice: 180.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 8,
    reviews: ['Review 1: High quality!', 'Review 2: Worth it!'],
    questions: ['Question 1: Features?', 'Question 2: Durability?'],
    imageUrl: 'lib/images/product5.jpg',
  ),
  Product(
    name: 'Product 6',
    description: 'Description of Product 6',
    price: 90.0,
    discountPrice: 80.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 18,
    reviews: ['Review 1: Functional!', 'Review 2: Sturdy!'],
    questions: ['Question 1: Compatibility?', 'Question 2: Maintenance?'],
    imageUrl: 'lib/images/product6.jpg',
  ),
  Product(
    name: 'Product 7',
    description: 'Description of Product 7',
    price: 110.0,
    discountPrice: 95.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 14,
    reviews: ['Review 1: Elegant product!', 'Review 2: Excellent design!'],
    questions: ['Question 1: Power consumption?', 'Question 2: User manual available?'],
    imageUrl: 'lib/images/product7.jpg',
  ),
  Product(
    name: 'Product 8',
    description: 'Description of Product 8',
    price: 130.0,
    discountPrice: 110.0,
    specs: ['Spec 1: Value', 'Spec 2: Value'],
    stock: 16,
    reviews: ['Review 1: Great value!', 'Review 2: Perfect!'],
    questions: ['Question 1: Warranty period?', 'Question 2: Product dimensions?'],
    imageUrl: 'lib/images/product8.jpg',
  ),
];
