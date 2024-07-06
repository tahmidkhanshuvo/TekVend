
import '../pages.dart'; // Adjust the import path based on your project structure

class UploadProductPage extends StatefulWidget {
  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final ProductUploader _productUploader = ProductUploader();

  // Form fields controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _specsController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _reviewsController = TextEditingController();
  final TextEditingController _questionsController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController(); // New controller for category
  final TextEditingController _brandController = TextEditingController(); // New controller for brand

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _discountPriceController.dispose();
    _specsController.dispose();
    _stockController.dispose();
    _reviewsController.dispose();
    _questionsController.dispose();
    _categoryController.dispose(); // Dispose category controller
    _brandController.dispose(); // Dispose brand controller
    super.dispose();
  }

  void _uploadProduct() {
    Product product = Product(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      description: _descriptionController.text,
      category: _categoryController.text, // Assign category from controller
      brand: _brandController.text, // Assign brand from controller
      discountPrice: double.parse(_discountPriceController.text),
      specs: _specsController.text.split(',').map((spec) => spec.trim()).toList(),
      stock: int.parse(_stockController.text),
      reviews: _reviewsController.text.split(',').map((review) => review.trim()).toList(),
      questions: _questionsController.text.split(',').map((question) => question.trim()).toList(),
    );

    _productUploader.uploadProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _discountPriceController,
              decoration: InputDecoration(labelText: 'Discount Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _specsController,
              decoration: InputDecoration(labelText: 'Specifications (comma-separated)'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _reviewsController,
              decoration: InputDecoration(labelText: 'Reviews (comma-separated)'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _questionsController,
              decoration: InputDecoration(labelText: 'Questions (comma-separated)'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _uploadProduct,
              child: Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }
}
