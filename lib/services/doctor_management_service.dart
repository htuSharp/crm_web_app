import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doctor_entry.dart';
import '../constants/data_management_constants.dart';

class DoctorManagementService {
  final List<DoctorEntry> _doctorsList = [];

  List<DoctorEntry> get doctorsList => List.unmodifiable(_doctorsList);

  // Common qualifications
  static const List<String> qualifications = [
    'MBBS',
    'MD',
    'MS',
    'DM',
    'MCh',
    'DNB',
    'MBBS, MD',
    'MBBS, MS',
    'MBBS, DNB',
    'BDS',
    'MDS',
    'BAMS',
    'BHMS',
    'BUMS',
    'BPT',
    'MPT',
    'Other',
  ];

  // Validation methods
  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Doctor name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateSpecialty(String? specialty) {
    if (specialty == null || specialty.isEmpty) {
      return 'Please select a specialty';
    }
    return null;
  }

  String? validateQualification(String? qualification) {
    if (qualification == null || qualification.isEmpty) {
      return 'Please select a qualification';
    }
    return null;
  }

  String? validateHospital(String hospital) {
    if (hospital.trim().isEmpty) {
      return 'Hospital/Clinic name cannot be empty';
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

  String? validateArea(String area) {
    if (area.trim().isEmpty) {
      return 'Area cannot be empty';
    }
    return null;
  }

  // Business logic methods
  bool isDuplicateDoctor(String name, {DoctorEntry? excluding}) {
    return _doctorsList.any(
      (entry) =>
          entry.name.toLowerCase() == name.toLowerCase() && entry != excluding,
    );
  }

  String addDoctor({
    required String name,
    required String specialty,
    required String qualification,
    required String hospital,
    required String contact,
    required String address,
    required String area,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final specialtyError = validateSpecialty(specialty);
    if (specialtyError != null) return specialtyError;

    final qualificationError = validateQualification(qualification);
    if (qualificationError != null) return qualificationError;

    final hospitalError = validateHospital(hospital);
    if (hospitalError != null) return hospitalError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final trimmedName = name.trim();
    if (isDuplicateDoctor(trimmedName)) {
      return 'Doctor "$trimmedName" already exists';
    }

    _doctorsList.add(
      DoctorEntry(
        name: trimmedName,
        specialty: specialty,
        qualification: qualification,
        hospital: hospital.trim(),
        contact: contact.trim(),
        address: address.trim(),
        area: area.trim(),
      ),
    );

    return 'success';
  }

  String editDoctor({
    required DoctorEntry oldEntry,
    required String name,
    required String specialty,
    required String qualification,
    required String hospital,
    required String contact,
    required String address,
    required String area,
  }) {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final specialtyError = validateSpecialty(specialty);
    if (specialtyError != null) return specialtyError;

    final qualificationError = validateQualification(qualification);
    if (qualificationError != null) return qualificationError;

    final hospitalError = validateHospital(hospital);
    if (hospitalError != null) return hospitalError;

    final contactError = validateContact(contact);
    if (contactError != null) return contactError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final trimmedName = name.trim();
    if (isDuplicateDoctor(trimmedName, excluding: oldEntry)) {
      return 'Doctor "$trimmedName" already exists';
    }

    final index = _doctorsList.indexOf(oldEntry);
    if (index != -1) {
      _doctorsList[index] = DoctorEntry(
        name: trimmedName,
        specialty: specialty,
        qualification: qualification,
        hospital: hospital.trim(),
        contact: contact.trim(),
        address: address.trim(),
        area: area.trim(),
      );
    }

    return 'success';
  }

  void deleteDoctor(DoctorEntry entry) {
    _doctorsList.remove(entry);
  }

  // Dialog helper methods
  void showAddDoctorDialog(BuildContext context, VoidCallback onSuccess) {
    _showDoctorDialog(context, onSuccess, null);
  }

  void showEditDoctorDialog(
    BuildContext context,
    DoctorEntry entry,
    VoidCallback onSuccess,
  ) {
    _showDoctorDialog(context, onSuccess, entry);
  }

  void _showDoctorDialog(
    BuildContext context,
    VoidCallback onSuccess,
    DoctorEntry? editEntry,
  ) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: editEntry?.name ?? '');
    final hospitalController = TextEditingController(
      text: editEntry?.hospital ?? '',
    );
    final contactController = TextEditingController(
      text: editEntry?.contact ?? '',
    );
    final addressController = TextEditingController(
      text: editEntry?.address ?? '',
    );
    final areaController = TextEditingController(text: editEntry?.area ?? '');

    String? selectedSpecialty =
        editEntry?.specialty ??
        (DataManagementConstants.specialties.isNotEmpty
            ? DataManagementConstants.specialties.first
            : null);
    String? selectedQualification =
        editEntry?.qualification ?? qualifications.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editEntry == null ? 'Add Doctor' : 'Edit Doctor'),
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
                      labelText: 'Doctor Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Dr. Full Name',
                    ),
                    validator: (value) => validateName(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedSpecialty,
                          decoration: const InputDecoration(
                            labelText: 'Specialty *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medical_services),
                          ),
                          items: DataManagementConstants.specialties
                              .map(
                                (spec) => DropdownMenuItem(
                                  value: spec,
                                  child: Text(spec),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => selectedSpecialty = val,
                          validator: (value) => validateSpecialty(value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedQualification,
                          decoration: const InputDecoration(
                            labelText: 'Qualification *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.school),
                          ),
                          items: qualifications
                              .map(
                                (qual) => DropdownMenuItem(
                                  value: qual,
                                  child: Text(qual),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => selectedQualification = val,
                          validator: (value) => validateQualification(value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: hospitalController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital/Clinic *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    validator: (value) => validateHospital(value ?? ''),
                    textCapitalization: TextCapitalization.words,
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
                    controller: areaController,
                    decoration: const InputDecoration(
                      labelText: 'Practice Area *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) => validateArea(value ?? ''),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
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
                  result = addDoctor(
                    name: nameController.text,
                    specialty: selectedSpecialty!,
                    qualification: selectedQualification!,
                    hospital: hospitalController.text,
                    contact: contactController.text,
                    address: addressController.text,
                    area: areaController.text,
                  );
                } else {
                  result = editDoctor(
                    oldEntry: editEntry,
                    name: nameController.text,
                    specialty: selectedSpecialty!,
                    qualification: selectedQualification!,
                    hospital: hospitalController.text,
                    contact: contactController.text,
                    address: addressController.text,
                    area: areaController.text,
                  );
                }

                if (result == 'success') {
                  Navigator.pop(context);
                  onSuccess();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        editEntry == null
                            ? 'Doctor added successfully!'
                            : 'Doctor updated successfully!',
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
