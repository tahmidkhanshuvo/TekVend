import '../pages.dart';

class AddressForm extends StatelessWidget {
  final void Function(Map<String, String>) onSave;
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  AddressForm({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          TextField(
            controller: stateController,
            decoration: const InputDecoration(labelText: 'State'),
          ),
          TextField(
            controller: zipController,
            decoration: const InputDecoration(labelText: 'ZIP Code'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSave({
                'address': addressController.text,
                'city': cityController.text,
                'state': stateController.text,
                'zip': zipController.text,
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }
}