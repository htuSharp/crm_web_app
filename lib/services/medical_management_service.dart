import 'package:flutter/material.dart';
import '../models/medical_entry.dart';
import '../services/headquarters_management_service.dart';
import '../services/area_management_service.dart';
import '../services/doctor_management_service.dart';
import '../repositories/medical_repository.dart';

class MedicalManagementService {
  final List<MedicalEntry> _medicalsList = [];
  final MedicalRepository _medicalRepository = MedicalRepository();
  bool _isLoading = false;
  String? _error;

  List<MedicalEntry> get medicalsList => List.unmodifiable(_medicalsList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Dependencies for dropdowns
  final HeadquartersManagementService _headquartersService =
      HeadquartersManagementService();
  final AreaManagementService _areaService = AreaManagementService();
  final DoctorManagementService _doctorService = DoctorManagementService();

  // Load medicals from Supabase
  Future<void> loadMedicals() async {
    _isLoading = true;
    _error = null;
    try {
      final medicals = await _medicalRepository.getAllMedicals();
      _medicalsList.clear();
      _medicalsList.addAll(medicals);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search medicals in Supabase
  Future<void> searchMedicals(String query) async {
    if (query.isEmpty) {
      await loadMedicals();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final medicals = await _medicalRepository.searchMedicals(query);
      _medicalsList.clear();
      _medicalsList.addAll(medicals);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

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

  String? validateHeadquarter(String? headquarter) {
    if (headquarter == null || headquarter.isEmpty) {
      return 'Please select a headquarter';
    }
    return null;
  }

  String? validateArea(String? area) {
    if (area == null || area.isEmpty) {
      return 'Please select an area';
    }
    return null;
  }

  String? validateContactPerson(String contactPerson) {
    if (contactPerson.trim().isEmpty) {
      return 'Contact person name cannot be empty';
    }
    if (contactPerson.trim().length < 2) {
      return 'Contact person name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhoneNo(String phoneNo) {
    if (phoneNo.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(phoneNo.trim())) {
      return 'Please enter a valid 10-digit phone number';
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

  String? validateAttachedDoctor(String? attachedDoctor) {
    if (attachedDoctor == null || attachedDoctor.isEmpty) {
      return 'Please select an attached doctor';
    }
    return null;
  }

  // Business logic methods
  Future<bool> isDuplicateMedical(
    String name, {
    MedicalEntry? excluding,
  }) async {
    try {
      final medicals = await _medicalRepository.searchMedicals(name);
      return medicals.any(
        (entry) =>
            entry.name.toLowerCase() == name.toLowerCase() &&
            entry != excluding,
      );
    } catch (e) {
      return false; // If error, allow operation to proceed
    }
  }

  Future<String> addMedical({
    required String name,
    required String headquarter,
    required String area,
    required String contactPerson,
    required String phoneNo,
    required String address,
    required String attachedDoctor,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final headquarterError = validateHeadquarter(headquarter);
    if (headquarterError != null) return headquarterError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final contactPersonError = validateContactPerson(contactPerson);
    if (contactPersonError != null) return contactPersonError;

    final phoneError = validatePhoneNo(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final doctorError = validateAttachedDoctor(attachedDoctor);
    if (doctorError != null) return doctorError;

    final trimmedName = name.trim();
    if (await isDuplicateMedical(trimmedName)) {
      return 'Medical facility "$trimmedName" already exists';
    }

    try {
      final newMedical = MedicalEntry(
        name: trimmedName,
        headquarter: headquarter,
        area: area,
        contactPerson: contactPerson.trim(),
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        attachedDoctor: attachedDoctor,
      );

      await _medicalRepository.createMedical(newMedical);
      _medicalsList.add(newMedical);
      return 'success';
    } catch (e) {
      return 'Failed to add medical: ${e.toString()}';
    }
  }

  Future<String> editMedical({
    required MedicalEntry oldEntry,
    required String name,
    required String headquarter,
    required String area,
    required String contactPerson,
    required String phoneNo,
    required String address,
    required String attachedDoctor,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final headquarterError = validateHeadquarter(headquarter);
    if (headquarterError != null) return headquarterError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final contactPersonError = validateContactPerson(contactPerson);
    if (contactPersonError != null) return contactPersonError;

    final phoneError = validatePhoneNo(phoneNo);
    if (phoneError != null) return phoneError;

    final addressError = validateAddress(address);
    if (addressError != null) return addressError;

    final doctorError = validateAttachedDoctor(attachedDoctor);
    if (doctorError != null) return doctorError;

    final trimmedName = name.trim();
    if (await isDuplicateMedical(trimmedName, excluding: oldEntry)) {
      return 'Medical facility "$trimmedName" already exists';
    }

    try {
      final updatedMedical = oldEntry.copyWith(
        name: trimmedName,
        headquarter: headquarter,
        area: area,
        contactPerson: contactPerson.trim(),
        phoneNo: phoneNo.trim(),
        address: address.trim(),
        attachedDoctor: attachedDoctor,
      );

      await _medicalRepository.updateMedical(updatedMedical);

      final index = _medicalsList.indexOf(oldEntry);
      if (index != -1) {
        _medicalsList[index] = updatedMedical;
      }
      return 'success';
    } catch (e) {
      return 'Failed to update medical: ${e.toString()}';
    }
  }

  // Delete medical with database integration
  Future<void> deleteMedical(MedicalEntry entry) async {
    try {
      await _medicalRepository.deleteMedical(entry.id!);
      _medicalsList.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete medical: ${e.toString()}');
    }
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
    final contactPersonController = TextEditingController(
      text: editEntry?.contactPerson ?? '',
    );
    final phoneController = TextEditingController(
      text: editEntry?.phoneNo ?? '',
    );
    final addressController = TextEditingController(
      text: editEntry?.address ?? '',
    );

    // Selected values
    String? selectedHeadquarter = editEntry?.headquarter;
    String? selectedArea = editEntry?.area;
    String? selectedDoctor = editEntry?.attachedDoctor;

    // Get available options
    final availableHeadquarters = _headquartersService.headquartersNames;
    final availableAreas = _areaService.areas;
    final availableDoctors = _doctorService.doctorsList;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            editEntry == null
                ? 'Add Medical Facility'
                : 'Edit Medical Facility',
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name field
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

                    // Headquarter dropdown
                    DropdownButtonFormField<String>(
                      value: selectedHeadquarter,
                      decoration: const InputDecoration(
                        labelText: 'Headquarter *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      items: availableHeadquarters.isEmpty
                          ? [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('No headquarters available'),
                              ),
                            ]
                          : availableHeadquarters
                                .map(
                                  (hq) => DropdownMenuItem<String>(
                                    value: hq,
                                    child: Text(hq),
                                  ),
                                )
                                .toList(),
                      onChanged: availableHeadquarters.isEmpty
                          ? null
                          : (val) {
                              setState(() {
                                selectedHeadquarter = val;
                                selectedArea =
                                    null; // Reset area when headquarter changes
                              });
                            },
                      validator: (value) => validateHeadquarter(value),
                    ),
                    const SizedBox(height: 16),

                    // Area dropdown
                    DropdownButtonFormField<String>(
                      value: selectedArea,
                      decoration: const InputDecoration(
                        labelText: 'Area *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.map),
                      ),
                      items: selectedHeadquarter == null
                          ? [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Select headquarter first'),
                              ),
                            ]
                          : availableAreas
                                .where(
                                  (area) =>
                                      area.headquarter == selectedHeadquarter,
                                )
                                .map(
                                  (area) => DropdownMenuItem(
                                    value: area.area,
                                    child: Text(area.area),
                                  ),
                                )
                                .toList(),
                      onChanged: selectedHeadquarter == null
                          ? null
                          : (val) {
                              setState(() {
                                selectedArea = val;
                              });
                            },
                      validator: (value) => validateArea(value),
                    ),
                    const SizedBox(height: 16),

                    // Contact Person field
                    TextFormField(
                      controller: contactPersonController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => validateContactPerson(value ?? ''),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number field
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        hintText: '9876543210',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) => validatePhoneNo(value ?? ''),
                    ),
                    const SizedBox(height: 16),

                    // Address field
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
                    const SizedBox(height: 16),

                    // Attached Doctor dropdown
                    DropdownButtonFormField<String>(
                      value: selectedDoctor,
                      decoration: const InputDecoration(
                        labelText: 'Attached Doctor *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      items: availableDoctors.isEmpty
                          ? [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('No doctors available'),
                              ),
                            ]
                          : availableDoctors
                                .map(
                                  (doctor) => DropdownMenuItem(
                                    value: doctor.name,
                                    child: Text(
                                      'Dr. ${doctor.name} (${doctor.specialty})',
                                    ),
                                  ),
                                )
                                .toList(),
                      onChanged: availableDoctors.isEmpty
                          ? null
                          : (val) {
                              setState(() {
                                selectedDoctor = val;
                              });
                            },
                      validator: (value) => validateAttachedDoctor(value),
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String result;
                  if (editEntry == null) {
                    result = await addMedical(
                      name: nameController.text,
                      headquarter: selectedHeadquarter!,
                      area: selectedArea!,
                      contactPerson: contactPersonController.text,
                      phoneNo: phoneController.text,
                      address: addressController.text,
                      attachedDoctor: selectedDoctor!,
                    );
                  } else {
                    result = await editMedical(
                      oldEntry: editEntry,
                      name: nameController.text,
                      headquarter: selectedHeadquarter!,
                      area: selectedArea!,
                      contactPerson: contactPersonController.text,
                      phoneNo: phoneController.text,
                      address: addressController.text,
                      attachedDoctor: selectedDoctor!,
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
      ),
    );
  }
}
