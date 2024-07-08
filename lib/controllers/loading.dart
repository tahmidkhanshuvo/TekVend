import '../pages.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(), // Loading indicator
          // Cart animation
          Positioned(
            top: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 50,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
