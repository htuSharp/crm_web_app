import 'package:flutter/material.dart';
import '../repositories/headquarters_repository.dart';

class HeadquartersManagementService {
  final List<Map<String, dynamic>> _headquartersList = [];
  final HeadquartersRepository _headquartersRepository =
      HeadquartersRepository();
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get headquartersList =>
      List.unmodifiable(_headquartersList);
  List<String> get headquartersNames =>
      _headquartersList.map((h) => h['name'] as String).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load headquarters from Supabase
  Future<void> loadHeadquarters() async {
    _isLoading = true;
    _error = null;
    try {
      final headquarters = await _headquartersRepository
          .getAllHeadquartersWithData();
      _headquartersList.clear();
      _headquartersList.addAll(headquarters);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search headquarters in Supabase
  Future<void> searchHeadquarters(String query) async {
    if (query.isEmpty) {
      await loadHeadquarters();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final headquarters = await _headquartersRepository.searchHeadquarters(
        query,
      );
      _headquartersList.clear();
      // Convert string results to map format for consistency
      _headquartersList.addAll(
        headquarters.map((name) => {'name': name}).toList(),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

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
  Future<bool> isDuplicateHeadquarters(
    String headquarters, {
    String? excluding,
  }) async {
    try {
      final headquartersList = await _headquartersRepository
          .getAllHeadquarters();
      return headquartersList.any(
        (item) =>
            item.toLowerCase() == headquarters.toLowerCase() &&
            item != excluding,
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> addHeadquarters(String headquarters) async {
    try {
      final error = validateHeadquarters(headquarters);
      if (error != null) return error;

      final trimmedHeadquarters = headquarters.trim();
      if (await isDuplicateHeadquarters(trimmedHeadquarters)) {
        return 'Headquarters "$trimmedHeadquarters" already exists';
      }

      await _headquartersRepository.createHeadquarters(trimmedHeadquarters);
      await loadHeadquarters(); // Refresh the list
      return 'success';
    } catch (e) {
      return 'Error adding headquarters: ${e.toString()}';
    }
  }

  Future<String> editHeadquarters(
    String oldHeadquarters,
    String newHeadquarters,
  ) async {
    try {
      final error = validateHeadquarters(newHeadquarters);
      if (error != null) return error;

      final trimmedHeadquarters = newHeadquarters.trim();
      if (await isDuplicateHeadquarters(
        trimmedHeadquarters,
        excluding: oldHeadquarters,
      )) {
        return 'Headquarters "$trimmedHeadquarters" already exists';
      }

      // Find the headquarters ID
      final headquarters = _headquartersList.firstWhere(
        (h) => h['name'] == oldHeadquarters,
        orElse: () => <String, dynamic>{},
      );

      if (headquarters.isEmpty) {
        return 'Headquarters not found';
      }

      await _headquartersRepository.updateHeadquarters(
        headquarters['id'],
        trimmedHeadquarters,
      );
      await loadHeadquarters(); // Refresh the list
      return 'success';
    } catch (e) {
      return 'Error editing headquarters: ${e.toString()}';
    }
  }

  Future<void> deleteHeadquarters(String headquarters) async {
    try {
      // Find the headquarters ID
      final headquartersData = _headquartersList.firstWhere(
        (h) => h['name'] == headquarters,
        orElse: () => <String, dynamic>{},
      );

      if (headquartersData.isEmpty) {
        throw Exception('Headquarters not found');
      }

      await _headquartersRepository.deleteHeadquarters(headquartersData['id']);
      await loadHeadquarters(); // Refresh the list
    } catch (e) {
      throw Exception('Error deleting headquarters: ${e.toString()}');
    }
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
            onPressed: () async {
              String result;
              if (editHeadquarters == null) {
                result = await addHeadquarters(controller.text);
              } else {
                result = await this.editHeadquarters(
                  editHeadquarters,
                  controller.text,
                );
              }

              if (result == 'success' && context.mounted) {
                Navigator.pop(context);
                onSuccess();
                if (context.mounted) {
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
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(editHeadquarters == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
