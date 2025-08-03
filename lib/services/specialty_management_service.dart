import 'package:flutter/material.dart';

class SpecialtyManagementService {
  final List<String> _specialtyList = [];

  List<String> get specialtyList => List.unmodifiable(_specialtyList);

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
  bool isDuplicateSpecialty(String specialty, {String? excluding}) {
    return _specialtyList.any(
      (item) =>
          item.toLowerCase() == specialty.toLowerCase() && item != excluding,
    );
  }

  String addSpecialty(String specialty) {
    final error = validateSpecialty(specialty);
    if (error != null) return error;

    final trimmedSpecialty = specialty.trim();
    if (isDuplicateSpecialty(trimmedSpecialty)) {
      return 'Specialty "$trimmedSpecialty" already exists';
    }

    _specialtyList.add(trimmedSpecialty);
    return 'success';
  }

  String editSpecialty(String oldSpecialty, String newSpecialty) {
    final error = validateSpecialty(newSpecialty);
    if (error != null) return error;

    final trimmedSpecialty = newSpecialty.trim();
    if (isDuplicateSpecialty(trimmedSpecialty, excluding: oldSpecialty)) {
      return 'Specialty "$trimmedSpecialty" already exists';
    }

    final index = _specialtyList.indexOf(oldSpecialty);
    if (index != -1) {
      _specialtyList[index] = trimmedSpecialty;
    }
    return 'success';
  }

  void deleteSpecialty(String specialty) {
    _specialtyList.remove(specialty);
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
            onPressed: () {
              String result;
              if (editSpecialty == null) {
                result = addSpecialty(controller.text);
              } else {
                result = this.editSpecialty(editSpecialty, controller.text);
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
