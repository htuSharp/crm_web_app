import 'package:flutter/material.dart';
import '../models/doctor_entry.dart';
import '../constants/data_management_constants.dart';
import '../services/area_management_service.dart';
import '../repositories/doctor_repository.dart';

class DoctorManagementService {
  final List<DoctorEntry> _doctorsList = [];
  final DoctorRepository _doctorRepository = DoctorRepository();
  bool _isLoading = false;
  String? _error;

  List<DoctorEntry> get doctorsList => List.unmodifiable(_doctorsList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Dependencies for dropdowns
  final AreaManagementService _areaService = AreaManagementService();

  // Load doctors from Supabase
  Future<void> loadDoctors() async {
    _isLoading = true;
    _error = null;
    try {
      final doctors = await _doctorRepository.getAllDoctors();
      _doctorsList.clear();
      _doctorsList.addAll(doctors);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Search doctors in Supabase
  Future<void> searchDoctors(String query) async {
    if (query.isEmpty) {
      await loadDoctors();
      return;
    }

    _isLoading = true;
    _error = null;
    try {
      final doctors = await _doctorRepository.searchDoctors(query);
      _doctorsList.clear();
      _doctorsList.addAll(doctors);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  // Available call days
  static const List<String> availableCallDays = [
    'All Days',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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

  String? validateArea(String? area) {
    if (area == null || area.isEmpty) {
      return 'Please select an area';
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

  String? validateCallDays(List<String> callDays) {
    if (callDays.isEmpty) {
      return 'Please select at least one call day';
    }
    return null;
  }

  String? validateDate(DateTime? date, String fieldName) {
    // Date validation is optional for birth date and marriage anniversary
    return null; // Allow null dates
  }

  // Business logic methods - Updated for Supabase
  Future<bool> isDuplicateDoctor(String name, {DoctorEntry? excluding}) async {
    try {
      final excludeId = excluding?.id;
      return await _doctorRepository.isDoctorNameExists(
        name,
        excludeId: excludeId,
      );
    } catch (e) {
      // Fallback to local check if Supabase fails
      return _doctorsList.any(
        (entry) =>
            entry.name.toLowerCase() == name.toLowerCase() &&
            entry != excluding,
      );
    }
  }

  Future<String> addDoctor({
    required String name,
    required String specialty,
    required String area,
    DateTime? dateOfBirth,
    required String phoneNo,
    DateTime? marriageAnniversary,
    required List<String> callDays,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final specialtyError = validateSpecialty(specialty);
    if (specialtyError != null) return specialtyError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final phoneError = validatePhoneNo(phoneNo);
    if (phoneError != null) return phoneError;

    final callDaysError = validateCallDays(callDays);
    if (callDaysError != null) return callDaysError;

    final trimmedName = name.trim();
    if (await isDuplicateDoctor(trimmedName)) {
      return 'Doctor "$trimmedName" already exists';
    }

    try {
      final newDoctor = DoctorEntry(
        name: trimmedName,
        specialty: specialty,
        area: area,
        dateOfBirth: dateOfBirth,
        phoneNo: phoneNo.trim(),
        marriageAnniversary: marriageAnniversary,
        callDays: List<String>.from(callDays),
      );

      final createdDoctor = await _doctorRepository.createDoctor(newDoctor);
      _doctorsList.add(createdDoctor);
      return 'success';
    } catch (e) {
      return 'Failed to add doctor: $e';
    }
  }

  Future<String> editDoctor({
    required DoctorEntry oldEntry,
    required String name,
    required String specialty,
    required String area,
    DateTime? dateOfBirth,
    required String phoneNo,
    DateTime? marriageAnniversary,
    required List<String> callDays,
  }) async {
    // Validate all fields
    final nameError = validateName(name);
    if (nameError != null) return nameError;

    final specialtyError = validateSpecialty(specialty);
    if (specialtyError != null) return specialtyError;

    final areaError = validateArea(area);
    if (areaError != null) return areaError;

    final phoneError = validatePhoneNo(phoneNo);
    if (phoneError != null) return phoneError;

    final callDaysError = validateCallDays(callDays);
    if (callDaysError != null) return callDaysError;

    final trimmedName = name.trim();
    if (await isDuplicateDoctor(trimmedName, excluding: oldEntry)) {
      return 'Doctor "$trimmedName" already exists';
    }

    try {
      final updatedDoctor = oldEntry.copyWith(
        name: trimmedName,
        specialty: specialty,
        area: area,
        dateOfBirth: dateOfBirth,
        phoneNo: phoneNo.trim(),
        marriageAnniversary: marriageAnniversary,
        callDays: List<String>.from(callDays),
      );

      final savedDoctor = await _doctorRepository.updateDoctor(updatedDoctor);

      final index = _doctorsList.indexOf(oldEntry);
      if (index != -1) {
        _doctorsList[index] = savedDoctor;
      }

      return 'success';
    } catch (e) {
      return 'Failed to update doctor: $e';
    }
  }

  Future<void> deleteDoctor(DoctorEntry entry) async {
    try {
      await _doctorRepository.deleteDoctor(entry.id);
      _doctorsList.remove(entry);
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
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
    final phoneController = TextEditingController(
      text: editEntry?.phoneNo ?? '',
    );

    // Selected values
    String? selectedSpecialty = editEntry?.specialty;
    String? selectedArea = editEntry?.area;
    DateTime? selectedDateOfBirth = editEntry?.dateOfBirth;
    DateTime? selectedMarriageAnniversary = editEntry?.marriageAnniversary;
    List<String> selectedCallDays = List<String>.from(
      editEntry?.callDays ?? [],
    );

    // Get available options
    final availableSpecialties = DataManagementConstants.specialties;
    final availableAreas = _areaService.areas;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(editEntry == null ? 'Add Doctor' : 'Edit Doctor'),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Doctor Name field
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

                    // Specialty dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSpecialty,
                      decoration: const InputDecoration(
                        labelText: 'Specialty *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      items: availableSpecialties.isEmpty
                          ? [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('No specialties available'),
                              ),
                            ]
                          : availableSpecialties
                                .map(
                                  (spec) => DropdownMenuItem(
                                    value: spec,
                                    child: Text(spec),
                                  ),
                                )
                                .toList(),
                      onChanged: availableSpecialties.isEmpty
                          ? null
                          : (val) {
                              setState(() {
                                selectedSpecialty = val;
                              });
                            },
                      validator: (value) => validateSpecialty(value),
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
                      items: availableAreas.isEmpty
                          ? [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('No areas available'),
                              ),
                            ]
                          : availableAreas
                                .map(
                                  (area) => DropdownMenuItem(
                                    value: area.area,
                                    child: Text(area.area),
                                  ),
                                )
                                .toList(),
                      onChanged: availableAreas.isEmpty
                          ? null
                          : (val) {
                              setState(() {
                                selectedArea = val;
                              });
                            },
                      validator: (value) => validateArea(value),
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth field
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              selectedDateOfBirth ??
                              DateTime.now().subtract(
                                const Duration(days: 365 * 30),
                              ),
                          firstDate: DateTime(1940),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDateOfBirth = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          selectedDateOfBirth != null
                              ? '${selectedDateOfBirth!.day}/${selectedDateOfBirth!.month}/${selectedDateOfBirth!.year}'
                              : 'Select date of birth',
                        ),
                      ),
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

                    // Marriage Anniversary field
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              selectedMarriageAnniversary ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedMarriageAnniversary = pickedDate;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Marriage Anniversary',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.favorite),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          selectedMarriageAnniversary != null
                              ? '${selectedMarriageAnniversary!.day}/${selectedMarriageAnniversary!.month}/${selectedMarriageAnniversary!.year}'
                              : 'Select marriage anniversary',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Call Days checkboxes
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Call Days *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: availableCallDays.map((day) {
                            final isSelected = selectedCallDays.contains(day);
                            return CheckboxListTile(
                              title: Text(day),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (day == 'All Days') {
                                    if (value == true) {
                                      selectedCallDays = List<String>.from(
                                        availableCallDays,
                                      );
                                    } else {
                                      selectedCallDays.clear();
                                    }
                                  } else {
                                    if (value == true) {
                                      selectedCallDays.add(day);
                                      selectedCallDays.remove('All Days');
                                    } else {
                                      selectedCallDays.remove(day);
                                      if (selectedCallDays.length ==
                                          availableCallDays.length - 1) {
                                        // If all individual days are selected, remove them and add 'All Days'
                                        final individualDays = availableCallDays
                                            .where((d) => d != 'All Days')
                                            .toList();
                                        if (individualDays.every(
                                          (d) => selectedCallDays.contains(d),
                                        )) {
                                          selectedCallDays = ['All Days'];
                                        }
                                      }
                                    }
                                  }
                                });
                              },
                              dense: true,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (selectedCallDays.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Please select at least one call day',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
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
                if (formKey.currentState!.validate() &&
                    selectedCallDays.isNotEmpty) {
                  String result;
                  try {
                    if (editEntry == null) {
                      result = await addDoctor(
                        name: nameController.text,
                        specialty: selectedSpecialty!,
                        area: selectedArea!,
                        dateOfBirth: selectedDateOfBirth,
                        phoneNo: phoneController.text,
                        marriageAnniversary: selectedMarriageAnniversary,
                        callDays: selectedCallDays,
                      );
                    } else {
                      result = await editDoctor(
                        oldEntry: editEntry,
                        name: nameController.text,
                        specialty: selectedSpecialty!,
                        area: selectedArea!,
                        dateOfBirth: selectedDateOfBirth,
                        phoneNo: phoneController.text,
                        marriageAnniversary: selectedMarriageAnniversary,
                        callDays: selectedCallDays,
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
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else if (selectedCallDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one call day'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
