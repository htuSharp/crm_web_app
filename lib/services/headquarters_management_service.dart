import 'package:flutter/material.dart';

class HeadquartersManagementService {
  final List<String> _headquartersList = [];

  List<String> get headquartersList => List.unmodifiable(_headquartersList);

  // Common headquarters/regions
  static const List<String> commonHeadquarters = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
    'Chandigarh',
    'Bhopal',
    'Indore',
    'Nagpur',
    'Coimbatore',
    'Kochi',
    'Thiruvananthapuram',
    'Bhubaneswar',
    'Guwahati',
    'Patna',
    'Ranchi',
    'Raipur',
    'Dehradun',
    'Shimla',
    'Srinagar',
  ];

  // Validation methods
  String? validateHeadquarters(String headquarters) {
    if (headquarters.trim().isEmpty) {
      return 'Headquarters name cannot be empty';
    }
    if (headquarters.trim().length < 2) {
      return 'Headquarters name must be at least 2 characters';
    }
    return null;
  }

  // Business logic methods
  bool isDuplicateHeadquarters(String headquarters, {String? excluding}) {
    return _headquartersList.any(
      (item) =>
          item.toLowerCase() == headquarters.toLowerCase() && item != excluding,
    );
  }

  String addHeadquarters(String headquarters) {
    final error = validateHeadquarters(headquarters);
    if (error != null) return error;

    final trimmedHeadquarters = headquarters.trim();
    if (isDuplicateHeadquarters(trimmedHeadquarters)) {
      return 'Headquarters "$trimmedHeadquarters" already exists';
    }

    _headquartersList.add(trimmedHeadquarters);
    return 'success';
  }

  String editHeadquarters(String oldHeadquarters, String newHeadquarters) {
    final error = validateHeadquarters(newHeadquarters);
    if (error != null) return error;

    final trimmedHeadquarters = newHeadquarters.trim();
    if (isDuplicateHeadquarters(
      trimmedHeadquarters,
      excluding: oldHeadquarters,
    )) {
      return 'Headquarters "$trimmedHeadquarters" already exists';
    }

    final index = _headquartersList.indexOf(oldHeadquarters);
    if (index != -1) {
      _headquartersList[index] = trimmedHeadquarters;
    }
    return 'success';
  }

  void deleteHeadquarters(String headquarters) {
    _headquartersList.remove(headquarters);
  }

  // Dialog helper methods
  void showAddHeadquartersDialog(BuildContext context, VoidCallback onSuccess) {
    _showHeadquartersDialog(context, onSuccess, null);
  }

  void showEditHeadquartersDialog(
    BuildContext context,
    String headquarters,
    VoidCallback onSuccess,
  ) {
    _showHeadquartersDialog(context, onSuccess, headquarters);
  }

  void _showHeadquartersDialog(
    BuildContext context,
    VoidCallback onSuccess,
    String? editHeadquarters,
  ) {
    final TextEditingController controller = TextEditingController(
      text: editHeadquarters ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editHeadquarters == null ? 'Add Headquarters' : 'Edit Headquarters',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Headquarters/Region Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
                hintText: 'e.g., Mumbai, Delhi, Bangalore',
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            if (editHeadquarters == null) ...[
              const Text(
                'Common Headquarters:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: commonHeadquarters
                    .take(8)
                    .map(
                      (hq) => ActionChip(
                        label: Text(hq),
                        onPressed: () {
                          controller.text = hq;
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String result;
              if (editHeadquarters == null) {
                result = addHeadquarters(controller.text);
              } else {
                result = this.editHeadquarters(
                  editHeadquarters,
                  controller.text,
                );
              }

              if (result == 'success') {
                Navigator.pop(context);
                onSuccess();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      editHeadquarters == null
                          ? 'Headquarters added successfully!'
                          : 'Headquarters updated successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result), backgroundColor: Colors.red),
                );
              }
            },
            child: Text(editHeadquarters == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
