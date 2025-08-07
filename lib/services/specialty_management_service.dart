import 'package:flutter/material.dart';
import '../repositories/specialty_repository.dart';

class SpecialtyManagementService {
  final List<Map<String, dynamic>> _specialtyList = [];
  final SpecialtyRepository _specialtyRepository = SpecialtyRepository();
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get specialtyList =>
      List.unmodifiable(_specialtyList);
  List<String> get specialtyNames =>
      _specialtyList.map((s) => s['name'] as String).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load specialties from Supabase
  Future<void> loadSpecialties() async {
    _isLoading = true;
    _error = null;
    try {
      final specialties = await _specialtyRepository
          .getAllSpecialtiesWithData();
      _specialtyList.clear();
      _specialtyList.addAll(specialties);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search specialties in Supabase
  Future<void> searchSpecialties(String query) async {
    if (query.isEmpty) {
      await loadSpecialties();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final specialties = await _specialtyRepository.searchSpecialties(query);
      _specialtyList.clear();
      // Convert string results to map format for consistency
      _specialtyList.addAll(specialties.map((name) => {'name': name}).toList());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Common medical specialties
  static const List<String> commonSpecialties = [
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Gynecology',
    'General Medicine',
    'Dermatology',
    'Ophthalmology',
    'ENT',
    'Psychiatry',
    'Radiology',
    'Pathology',
    'Anesthesiology',
    'Emergency Medicine',
    'General Surgery',
    'Nephrology',
    'Gastroenterology',
    'Pulmonology',
    'Oncology',
    'Endocrinology',
    'Rheumatology',
    'Urology',
    'Plastic Surgery',
    'Dental',
    'Physiotherapy',
  ];

  // Validation methods
  String? validateSpecialty(String specialty) {
    if (specialty.trim().isEmpty) {
      return 'Specialty name cannot be empty';
    }
    if (specialty.trim().length < 3) {
      return 'Specialty name must be at least 3 characters';
    }
    return null;
  }

  // Business logic methods
  Future<bool> isDuplicateSpecialty(
    String specialty, {
    String? excluding,
  }) async {
    try {
      final specialties = await _specialtyRepository.getAllSpecialties();
      return specialties.any(
        (item) =>
            item.toLowerCase() == specialty.toLowerCase() && item != excluding,
      );
    } catch (e) {
      return false;
    }
  }

  Future<String> addSpecialty(String specialty) async {
    try {
      final error = validateSpecialty(specialty);
      if (error != null) return error;

      final trimmedSpecialty = specialty.trim();
      if (await isDuplicateSpecialty(trimmedSpecialty)) {
        return 'Specialty "$trimmedSpecialty" already exists';
      }

      await _specialtyRepository.createSpecialty(trimmedSpecialty);
      await loadSpecialties(); // Refresh the list
      return 'success';
    } catch (e) {
      return 'Error adding specialty: ${e.toString()}';
    }
  }

  Future<String> editSpecialty(String oldSpecialty, String newSpecialty) async {
    try {
      final error = validateSpecialty(newSpecialty);
      if (error != null) return error;

      final trimmedSpecialty = newSpecialty.trim();
      if (await isDuplicateSpecialty(
        trimmedSpecialty,
        excluding: oldSpecialty,
      )) {
        return 'Specialty "$trimmedSpecialty" already exists';
      }

      // Find the specialty ID
      final specialty = _specialtyList.firstWhere(
        (s) => s['name'] == oldSpecialty,
        orElse: () => <String, dynamic>{},
      );

      if (specialty.isEmpty) {
        return 'Specialty not found';
      }

      await _specialtyRepository.updateSpecialty(
        specialty['id'],
        trimmedSpecialty,
      );
      await loadSpecialties(); // Refresh the list
      return 'success';
    } catch (e) {
      return 'Error editing specialty: ${e.toString()}';
    }
  }

  Future<void> deleteSpecialty(String specialty) async {
    try {
      // Find the specialty ID
      final specialtyData = _specialtyList.firstWhere(
        (s) => s['name'] == specialty,
        orElse: () => <String, dynamic>{},
      );

      if (specialtyData.isEmpty) {
        throw Exception('Specialty not found');
      }

      await _specialtyRepository.deleteSpecialty(specialtyData['id']);
      await loadSpecialties(); // Refresh the list
    } catch (e) {
      throw Exception('Error deleting specialty: ${e.toString()}');
    }
  }

  // Dialog helper methods
  void showAddSpecialtyDialog(BuildContext context, VoidCallback onSuccess) {
    _showSpecialtyDialog(context, onSuccess, null);
  }

  void showEditSpecialtyDialog(
    BuildContext context,
    String specialty,
    VoidCallback onSuccess,
  ) {
    _showSpecialtyDialog(context, onSuccess, specialty);
  }

  void _showSpecialtyDialog(
    BuildContext context,
    VoidCallback onSuccess,
    String? editSpecialty,
  ) {
    final TextEditingController controller = TextEditingController(
      text: editSpecialty ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editSpecialty == null
              ? 'Add Medical Specialty'
              : 'Edit Medical Specialty',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Specialty Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
                hintText: 'e.g., Cardiology, Neurology',
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            if (editSpecialty == null) ...[
              const Text(
                'Common Specialties:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: commonSpecialties
                    .take(6)
                    .map(
                      (specialty) => ActionChip(
                        label: Text(specialty),
                        onPressed: () {
                          controller.text = specialty;
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
              if (editSpecialty == null) {
                result = await addSpecialty(controller.text);
              } else {
                result = await this.editSpecialty(
                  editSpecialty,
                  controller.text,
                );
              }

              if (result == 'success') {
                Navigator.pop(context);
                onSuccess();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      editSpecialty == null
                          ? 'Medical specialty added successfully!'
                          : 'Medical specialty updated successfully!',
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
            child: Text(editSpecialty == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
