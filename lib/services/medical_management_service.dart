import 'package:flutter/material.dart';
import '../models/medical_entry.dart';

class MedicalManagementService {
  final List<MedicalEntry> _medicalsList = [];

  List<MedicalEntry> get medicalsList => List.unmodifiable(_medicalsList);

  // Medical types
  static const List<String> medicalTypes = [
    'Hospital',
    'Clinic',
    'Nursing Home',
    'Diagnostic Center',
    'Pharmacy',
    'Medical Store',
    'Health Center',
    'Dispensary',
  ];

  static const List<String> specializations = [
    'General Medicine',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Gynecology',
    'Dermatology',
    'ENT',
    'Ophthalmology',
    'Psychiatry',
    'Radiology',
    'Pathology',
    'Emergency Medicine',
    'Multi-Specialty',
  ];

  // Validation methods
  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Medical facility name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateType(String? type) {
    if (type == null || type.isEmpty) {
      return 'Please select a medical facility type';
    }
    return null;
  }

  String? validateContact(String contact) {
    if (contact.trim().isEmpty) {
      return 'Contact information cannot be empty';
    }
    if (contact.trim().length < 10) {
      return 'Please provide complete contact information';
    }
    return null;
  }

  String? validateAddress(String address) {
    if (address.trim().isEmpty) {
      return 'Address cannot be empty';
    }
    if (address.trim().length < 10) {
      return 'Please provide a complete address';
    }
    return null;
  }

  String? validateSpecialization(String? specialization) {
    if (specialization == null || specialization.isEmpty) {
      return 'Please select a specialization';
    }
    return null;
  }

  // Business logic methods
  bool isDuplicateMedical(String name, {MedicalEntry? excluding}) {
    return _medicalsList.any(
      (entry) =>
          entry.name.toLowerCase() == name.toLowerCase() && entry != excluding,
    );
  }

  String addMedical({
    required String name,
    required String type,
    required String contact,
    required String address,
    required String specialization,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final typeError = validateType(type);
    if (typeError != null) return typeError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final specializationError = validateSpecialization(specialization);
    if (specializationError != null) return specializationError;

    final trimmedName = name.trim();
    if (isDuplicateMedical(trimmedName)) {
      return 'Medical facility "$trimmedName" already exists';
    }

    _medicalsList.add(
      MedicalEntry(
        name: trimmedName,
        type: type,
        contact: contact.trim(),
        address: address.trim(),
        specialization: specialization,
      ),
    );

    return 'success';
  }

  String editMedical({
    required MedicalEntry oldEntry,
    required String name,
    required String type,
    required String contact,
    required String address,
    required String specialization,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final typeError = validateType(type);
    if (typeError != null) return typeError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final specializationError = validateSpecialization(specialization);
    if (specializationError != null) return specializationError;

    final trimmedName = name.trim();
    if (isDuplicateMedical(trimmedName, excluding: oldEntry)) {
      return 'Medical facility "$trimmedName" already exists';
    }

    final index = _medicalsList.indexOf(oldEntry);
    if (index != -1) {
      _medicalsList[index] = MedicalEntry(
        name: trimmedName,
        type: type,
        contact: contact.trim(),
        address: address.trim(),
        specialization: specialization,
      );
    }

    return 'success';
  }

  void deleteMedical(MedicalEntry entry) {
    _medicalsList.remove(entry);
  }

  // Dialog helper methods
  void showAddMedicalDialog(BuildContext context, VoidCallback onSuccess) {
    _showMedicalDialog(context, onSuccess, null);
  }

  void showEditMedicalDialog(
    BuildContext context,
    MedicalEntry entry,
    VoidCallback onSuccess,
  ) {
    _showMedicalDialog(context, onSuccess, entry);
  }

  void _showMedicalDialog(
    BuildContext context,
    VoidCallback onSuccess,
    MedicalEntry? editEntry,
  ) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: editEntry?.name ?? '');
    final contactController = TextEditingController(
      text: editEntry?.contact ?? '',
    );
    final addressController = TextEditingController(
      text: editEntry?.address ?? '',
    );

    String? selectedType = editEntry?.type ?? medicalTypes.first;
    String? selectedSpecialization =
        editEntry?.specialization ?? specializations.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editEntry == null ? 'Add Medical Facility' : 'Edit Medical Facility',
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Facility Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    validator: (value) => validateName(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Facility Type *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: medicalTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (val) => selectedType = val,
                    validator: (value) => validateType(value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSpecialization,
                    decoration: const InputDecoration(
                      labelText: 'Specialization *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                    items: specializations
                        .map(
                          (spec) =>
                              DropdownMenuItem(value: spec, child: Text(spec)),
                        )
                        .toList(),
                    onChanged: (val) => selectedSpecialization = val,
                    validator: (value) => validateSpecialization(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Information *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Phone, Email, etc.',
                    ),
                    validator: (value) => validateContact(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 3,
                    validator: (value) => validateAddress(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String result;
                if (editEntry == null) {
                  result = addMedical(
                    name: nameController.text,
                    type: selectedType!,
                    contact: contactController.text,
                    address: addressController.text,
                    specialization: selectedSpecialization!,
                  );
                } else {
                  result = editMedical(
                    oldEntry: editEntry,
                    name: nameController.text,
                    type: selectedType!,
                    contact: contactController.text,
                    address: addressController.text,
                    specialization: selectedSpecialization!,
                  );
                }

                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        editEntry == null
                            ? 'Medical facility added successfully!'
                            : 'Medical facility updated successfully!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(editEntry == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
