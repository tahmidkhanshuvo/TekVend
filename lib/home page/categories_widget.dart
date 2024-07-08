import '../pages.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  bool _showAllCategories = false;

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryItem(name: 'Processors', icon: Icons.memory),
      CategoryItem(name: 'Laptop', icon: Icons.computer),
      CategoryItem(name: 'GPU', icon: Icons.videogame_asset),
      CategoryItem(name: 'RAM', icon: Icons.sd_card),
      CategoryItem(name: 'Storage', icon: Icons.storage),
      CategoryItem(name: 'PSU', icon: Icons.battery_charging_full),
      CategoryItem(name: 'Cooling', icon: Icons.ac_unit),
      CategoryItem(name: 'Monitors', icon: Icons.tv),
      CategoryItem(name: 'Keyboards', icon: Icons.keyboard),
      CategoryItem(name: 'Mice', icon: Icons.mouse),
      CategoryItem(name: 'Headphones', icon: Icons.headset),
      CategoryItem(name: 'Speakers', icon: Icons.speaker),
      CategoryItem(name: 'Cases', icon: Icons.desktop_windows),
      CategoryItem(name: 'Networking', icon: Icons.router),
      CategoryItem(name: 'Software', icon: Icons.code),
      CategoryItem(name: 'Accessories', icon: Icons.miscellaneous_services),
    ];

    final visibleCategories = _showAllCategories ? categories : categories.take(8).toList();

    return Column(
      children: [
        SizedBox(
          height: _showAllCategories ? 320 : 160, // Adjust the height to accommodate more categories
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            itemCount: visibleCategories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigate to the category products page
                  Get.toNamed('/categoryProducts', arguments: visibleCategories[index].name);
                },
                child: visibleCategories[index],
              );
            },
          ),
        ),
        if (!_showAllCategories)
          TextButton(
            onPressed: () {
              setState(() {
                _showAllCategories = true;
              });
            },
            child: const Text('Show More'),
          ),
        if (_showAllCategories)
          TextButton(
            onPressed: () {
              setState(() {
                _showAllCategories = false;
              });
            },
            child: const Text('Show Less'),
          ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 36),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
